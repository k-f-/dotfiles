### Mac and Linux work the same, storing the keys in ~/.gnupg. 
The safest way to transfer the files is using scp (part of ssh):

To copy from your local machine to another:
``scp -rp ~/.gnupg othermachine:``

To copy from a remote machine to your local:
``scp -r othermachine:~/.gnupg ~``

If you're on the machine that already has the key:

``gpg --export-secret-key SOMEKEYID | ssh othermachine gpg --import``

If you're on the machine that needs the key:

``ssh othermachine gpg --export-secret-key SOMEKEYID | gpg --import``
