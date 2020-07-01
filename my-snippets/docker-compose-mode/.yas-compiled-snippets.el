;;; Compiled snippets and support files for `docker-compose-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'docker-compose-mode
                     '(("docker-compose-template" "version: \"3.7\"\nservices:\n  ${1:SERVICENAME}:\n    build:\n      context: ${2:folder-to-build-from}\ncontainer_name: ${3:container-name}\nenv_file:\nenvironment:\nnetworks:\n  - internal-network\nports:\n  - \"${4:0000}:${5:0000}\"\nrestart: always\nvolumes:\n  - type: volume\n    source: ${6:docker-volume}\n    target: ${7:inside-docker}\n  \nnetworks:\n  internal-network:\n    # Bridge network to allow inter-communication between the dockers but no external facing connectios\n    driver: bridge\n    \nvolumes:\n  $6:" "docker-compose-template" nil nil nil "/Users/CCCP/.emacs.d/my-snippets/docker-compose-mode/docker-compose-template" nil nil)))


;;; Do not edit! File generated at Tue Jun 30 21:58:25 2020
