#!/bin/bash
set -e

NAMESPACE="core"
REMOTE_DIR="/opt/app/tmp/report"
REMOTE_FILE_NAME="rbspy-output.raw.gz"
REMOTE_FILE_PATH="$REMOTE_DIR/$REMOTE_FILE_NAME"

DURATION=${1:-100}

echo "--- Starting CPU Profile ---"
echo "Target Namespace: $NAMESPACE"
echo "Profile Duration: ${DURATION}s"
echo

echo "[1/7] Finding highest CPU pod in namespace '$NAMESPACE'..."
POD_NAME=$(timeout 10s kubectl top pods -n $NAMESPACE --sort-by=cpu | tail -n +2 | head -n 1 | awk '{print $1}')
if [ -z "$POD_NAME" ]; then
  echo "Error: Could not find any pods in namespace $NAMESPACE."
  echo "This command may also fail if the Kubernetes Metrics Server is not responding."
  exit 1
fi
echo "Found highest CPU pod: $POD_NAME"

echo "[2/7] Finding highest CPU puma worker in $POD_NAME..."
HEAVY_PROCESS_LINE=$(kubectl exec "$POD_NAME" -n $NAMESPACE -- sh -c "ps -eo pid,%cpu,args | grep 'puma: cluster worker' | grep -v 'grep' | sort -k 2 -n -r | head -n 1")
if [ -z "$HEAVY_PROCESS_LINE" ]; then
  echo "Error: Could not find a 'puma: cluster worker' process in $POD_NAME."
  echo "Checking for any puma process..."
  HEAVY_PROCESS_LINE=$(kubectl exec "$POD_NAME" -n $NAMESPACE -- sh -c "ps -eo pid,%cpu,args | grep 'puma' | grep -v 'PID' | grep -v 'grep' | sort -k 2 -n -r | head -n 1")
  if [ -z "$HEAVY_PROCESS_LINE" ]; then
    echo "Error: Could not find any puma process in $POD_NAME."
    exit 1
  fi
fi

TARGET_PID=$(echo $HEAVY_PROCESS_LINE | awk '{print $1}')
echo "Found target worker (line: $HEAVY_PROCESS_LINE)"
echo "Extracted PID: $TARGET_PID"

echo "[3/7] Creating remote directory '$REMOTE_DIR' on pod..."
kubectl exec "$POD_NAME" -n $NAMESPACE -- mkdir -p $REMOTE_DIR

echo "[4/7] Running rbspy on $POD_NAME (PID: $TARGET_PID) for $DURATION seconds..."
kubectl exec "$POD_NAME" -n $NAMESPACE -- \
  rbspy record --pid $TARGET_PID \
  --raw-file=$REMOTE_FILE_PATH \
  --rate 100 --subprocesses --duration $DURATION --silent
echo "rbspy capture finished."

LOCAL_DIR="rbspy_report_$(date +%Y%m%d_%H%M%S)"
echo "[5/7] Copying '$REMOTE_DIR' from pod to local directory './$LOCAL_DIR'..."
rm -rf ./report
kubectl cp "$NAMESPACE/$POD_NAME:$REMOTE_DIR" ./report
mv ./report "./$LOCAL_DIR"
echo "Report saved to ./$LOCAL_DIR"

echo "[6/7] Generating Speedscope report..."
cd "./$LOCAL_DIR"
rbspy report --input $REMOTE_FILE_NAME -f speedscope -o speedscope.json
echo "Generated speedscope.json"

echo "[7/7] Opening Speedscope..."
speedscope speedscope.json

echo
echo "--- Profile complete. ---"
echo "Your report files are located in: $(pwd)"
