function install_vscode_extensions(){
  chmod +x ./extensions.sh

  echo "Installing VSCODE Extensions...🚀"

  while read extension; do {
    ${extension}
  } done < ./extensions.sh
}