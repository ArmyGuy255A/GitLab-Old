#Vault
vaultConfigDir="Vault/config"
vaultConfigVolumeDir="Vault/volumes/config"

for dir in $vaultConfigVolumeDir
do
    mkdir -p $dir
    cp $vaultConfigDir/* $vaultConfigVolumeDir
done