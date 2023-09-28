eval $(ssh-agent -s) &> /dev/null
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_dbx_github &> /dev/null
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_dbx &> /dev/null
ssh-add --apple-use-keychain ~/.ssh/id_ed25519 &> /dev/null
