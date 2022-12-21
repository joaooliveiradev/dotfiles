#!/bin/bash

chmod +x ./vscode/extensions.sh

echo "Installing VSCODE Extensions...🚀"

while read extension; do {
  ${extension}
} done < ./vscode/extensions.sh




