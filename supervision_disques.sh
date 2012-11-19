#!/bin/bash
################################################################################
#       Script de supervision d'espaces disques sous Linux                     #
#       Le serveur doit pouvoir envoyer des mails (avec sendmail par exemple)  #
#       Version : 1.5                                                          #
#       Test réalisé sur RedHat6.2 avec l'utilisateur "root"                   #
################################################################################

# Mails séparés par des espaces
email="username@domaine.com"

# Répertoire de destination du fichier d'alerte
loghome="/tmp"

# Récupération du nom de la machine
systeme=`hostname`

for line in $(df -h |grep -v tmpfs | grep "^/" | grep "\%" | sort | awk '{ print $6"-"$5"-"$4}')
do
        pctage=$(echo $line | awk -F"-" '{print $2}' | cut -d % -f 1 )
        partition=$(echo $line | awk -F"-" '{print $1}')
        taille=$(echo $line | awk -F"-" '{print $3}')
        # Seuil à partir duquel une alerte est lancée, en pourcentage
        limite=95
        # Pour éviter les faux positifs avec les CD/DVD
        if [ $partition == "/cdrom" ]
        then
                limite=101
        fi
        # Enregistre une alerte si le pourcentage d'occupation est supérieur à notre limite
        if [ $pctage -ge $limite ]
        then
                echo "Sur $systeme - La partition $partition atteint $pctage % soit $taille de libre " >> $loghome/mail_disque.tmp
                echo "" >> $loghome/mail_disque.tmp
        fi
done
# Envoi d'un mail si le fichier d'alerte existe
if [ -f $loghome/mail_disque.tmp ]
then
        df -h |grep -v tmpfs >> $loghome/mail_disque.tmp
        cat $loghome/mail_disque.tmp | mail -s "[Alerte] Espace disque critique sur $systeme" $email
        rm -f $loghome/mail_disque.tmp
fi

