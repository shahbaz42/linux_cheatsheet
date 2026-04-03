#!/bin/bash

encrypt=false
decrypt=false
remove=false
filepath=""

show_help() {
echo "Kavach - Simple Encryption Tool"
echo ""
echo "Usage:"
echo "  kavach -e -f <file/folder> [-r]   Encrypt file/folder"
echo "  kavach -d -f <file>               Decrypt file"
echo ""
echo "Options:"
echo "  -e        Encrypt"
echo "  -d        Decrypt"
echo "  -f PATH   File or folder path"
echo "  -r        Remove original after encryption"
echo "  -h        Show help"
echo ""
echo "Examples:"
echo "  kavach -e -f secrets"
echo "  kavach -e -r -f ./abc"
echo "  kavach -d -f secrets.tar.gz.gpg"
echo ""
}

while getopts "edrf:h" opt; do
  case $opt in
    e) encrypt=true ;;
    d) decrypt=true ;;
    r) remove=true ;;
    f) filepath="$OPTARG" ;;
    h) show_help
       exit 0 ;;
    *) show_help
       exit 1 ;;
  esac
done

if [ -z "$filepath" ]; then
  echo "❌ File/folder not provided"
  echo ""
  show_help
  exit 1
fi

# Encrypt
if [ "$encrypt" = true ]; then

  if [ ! -e "$filepath" ]; then
    echo "❌ File or folder does not exist"
    exit 1
  fi

  name=$(basename "$filepath")

  echo "🔐 Encrypting $filepath..."

  tar -czf - "$filepath" | gpg -c -o "${name}.tar.gz.gpg"

  if [ $? -eq 0 ]; then
    echo "✅ Encrypted -> ${name}.tar.gz.gpg"

    if [ "$remove" = true ]; then
      echo "🗑 Removing original..."
      rm -rf "$filepath"
      echo "✅ Original removed"
    fi
  else
    echo "❌ Encryption failed"
  fi
fi

# Decrypt
if [ "$decrypt" = true ]; then

  if [ ! -f "$filepath" ]; then
    echo "❌ Encrypted file not found"
    exit 1
  fi

  echo "🔓 Decrypting $filepath..."

  gpg -d "$filepath" | tar -xz

  if [ $? -eq 0 ]; then
    echo "✅ Decryption successful"
  else
    echo "❌ Decryption failed"
  fi
fi
