#!/bin/bash
if [ $(id -u) -eq 0 ]; then
ajouter () {
    read -p "Enter username: " nomdu
    egrep "^$nomdu" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
        echo "$nomdu exists!"
        exit 1
    else
        read -s -p "Enter password: " password
        echo
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
        useradd -m -p $pass $nomdu
        [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
        exit
    fi
}

supprimer () {
    read -p "Enter username: " nomdu
    egrep "^$nomdu" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
        read -p "Options for userdel (ie, -r to delete home directory as well): " opts
        userdel $opts $nomdu
        [ $? -eq 0 ] && echo "Deleted user!" || echo "Failed to delete user!"
        exit
    else
        echo "That user doesn't exist!"
        exit 1
    fi
}

demande () {
    read -rp "Add or remove user: " command
    if [ "$command" = "add" ]
      then
      ajouter
    fi
    if [ "$command" = "remove" ]
      then
      supprimer
   fi
    echo "invalid option"
    demande #recursion! :D
}

case $1 in
    -a|add)
    ajouter
    exit
    ;;
    -r|remove)
    supprimer
    exit
    ;;
    *)
    #Il n'y avait pas une option donnee, alors on doit demander l'utilisateur.
    demande
    exit
    ;;
esac
else
    echo "Only root may add a user to the system"
    exit 2
fi
