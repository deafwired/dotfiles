#!/bin/sh
# sudo pacman -Syu --needed - <pacmanPackages.txt
# yay -Syu --needed - <yayPackages.txt
# chsh -s $(which fish)
dir=$(pwd)
# exclude txt files (packages to install) and this script
files=($(ls "$dir" | grep -Ev ".txt$|\.sh$"))
for i in "${!files[@]}"; do
	echo "$((i + 1)). ${files[i]}"
done
echo "Enter the numbers corresponding to the files you want to link (type 0 for all, no spaces)"
read -r chosen_numbers
if [ "$chosen_numbers" -eq 0 ]; then
	echo "Linking all files"
	for chosen_file in "${files[@]}"; do
		full_path="$dir/$chosen_file"
		echo "Linking file: $full_path"
		ln -s "$full_path" "$HOME/.config/"
	done
else
	for ((i = 0; i < ${#chosen_numbers}; i++)); do
		digit="${chosen_numbers:i:1}"
		index=$((digit - 1))
		if [ "$index" -ge 0 ] && [ "$index" -lt "${#files[@]}" ]; then
			chosen_file="${files[$index]}"
			full_path="$dir/$chosen_file"
			echo "Linking file: $full_path"
			ln -s "$full_path" "$HOME/.config/"
		else
			echo "Invalid selection: $digit"
		fi
	done
fi
