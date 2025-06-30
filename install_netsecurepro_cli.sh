#!/bin/bash

DEB_FILE="netsecurepro_web_cli_REAL.deb"

echo "🔧 [INFO] Vérification du système..."

if [ ! -f "$DEB_FILE" ]; then
    echo "❌ Fichier $DEB_FILE introuvable."
    exit 1
fi

# Fonction d'installation sous Debian/Ubuntu
install_in_debian() {
    echo "🔄 Installation de $DEB_FILE..."
    sudo dpkg -i "$DEB_FILE"
    echo "🧩 Résolution des dépendances..."
    sudo apt-get install -f -y
    echo "✅ Installation terminée."
}

# Détection de Termux ou Ubuntu/Debian natif
if uname -a | grep -qi termux; then
    echo "📱 [Termux détecté]"

    if command -v proot-distro >/dev/null 2>&1; then
        echo "✅ proot-distro est installé."

        DISTRO_NAME="debian"
        echo "🔄 Lancement de $DISTRO_NAME..."

        proot-distro login $DISTRO_NAME --shared-tmp -- bash -c "
            cd /data/data/com.termux/files/home
            apt update && apt install -y sudo
            echo '🔧 Installation dans proot-distro...'
            sudo dpkg -i $DEB_FILE
            sudo apt-get install -f -y
            echo '✅ [proot-distro] Installation complète dans $DISTRO_NAME.'
        "

    else
        echo "❌ proot-distro n’est pas installé. Installez-le avec :"
        echo "pkg install proot-distro"
        exit 1
    fi

else
    echo "💻 [Système Linux détecté - hors Termux]"
    install_in_debian
fi
