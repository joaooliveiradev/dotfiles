#!/bin/bash

chmod +x ./extensions.sh

echo "Installing VSCODE Extensions...🚀"

while read extension; do {
  {extension}
} done < ./extensions.sh