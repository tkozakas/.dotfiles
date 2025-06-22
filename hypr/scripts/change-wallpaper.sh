DIR="$HOME/.config/hypr/wallpapers"
F=$(find "$DIR" -type f | shuf -n1)

for M in $(hyprctl monitors -j | jq -r '.[].name'); do
  hyprctl hyprpaper preload "$F"
  hyprctl hyprpaper wallpaper "$M,$F"
  hyprctl hyprpaper unload unused
done
