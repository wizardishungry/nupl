===[ nupl - the nu plan script ]=======================================

 Author:         Craig Harman      (craig@cif.rochester.edu)
 Created:        Sometime in 1997
 Last modified:  8 April 2002
 License:        GNU General Public License (GPL) - see below


 -----------
 What is it?
 -----------

   nupl is a Perl script designed to check for new plans.  If you
   finger a group of friends frequently, and their .plan files
   change frequently, then you may find nupl useful.

   To use nupl, you must create a text file with a list of usernames.
   nupl will look at the .plan file of each username that you give
   it, and then display all of the .plan's that have changes since
   the last time you ran nupl.  nupl can check .plan's on both local
   and remote email servers.


 ------------------
 Quick Instructions
 ------------------

   [1]  Get your hands on a copy of nupl

   [2]  At your command prompt, type:

          perl nupl install

   [3]  Create a file called .nuplist in your home directory using
        your favorite text editor.  Each line of the file should
        contain the username of someone you want to finger.  For
        example, a .nuplist file could contain the lines:

          craig
          aaron
          pr005f@mail.rochester.edu

        This file tells nupl to finger the users 'craig' and 'aaron'
        on the local system, and the user 'pr005f' on the remote
        system 'mail.rochester.edu'.

   [4]  Run nupl whenever you want to check your friends' .plans


 ---------------------
 Detailed Instructions
 ---------------------

   I have tried to make as few assumptions about your familiarity with
   UNIX as possible.  I do assume that you are familiar with a text
   editor, such as joe or pico.  pico is the default editor for Pine,
   so if you can compose email with Pine, you can use pico.

   I also refer to your 'home directory' in the following instructions.
   Your home directory is the directory that you start in when you
   login to mail.  The ~ (tilde) character is a special UNIX alias
   for a home directory.  You can always get to your home directory
   by typing

      cd ~

   at a command prompt.

   [1]  Copy nupl (this file) to your home directory.  If nupl was sent to
        you as an email attachment, then save the attachment to your home
        directory.  If you know one of your friends has nupl installed
        on your email server, you should be able to copy it your home
        directory using something like this:

           cp ~craig/nupl ~

   [2]  Once you have a copy of nupl in your home directory, you can
        install it by typing:

           perl nupl install

        If the installation is successful, nupl will print instructions
        about how to use it.

   [3]  The next step is to create a file called .nuplist in your
        home directory using your favorite text editor.  To do this
        using pico, you would type

           pico ~/.nuplist

        at a command prompt.

        The .nuplist file should have one username on each line.
        The user you want to finger can have an account on the
        machine that you are running the nupl script on (local
        user) or an account on another machine (remote user).
        Entries in the .nuplist file will need to have a different
        form for local users than for remote users.

        LOCAL USERS:

        A sample .nuplist file containing local user entries might
        look something like this:

           ch001e
           cc012c
           ep001b


        REMOTE USERS

        nupl determines if a local user's .plan has changed by checking
        the time that the .plan file was last modified.  This approach
        will not work for users on remote systems since nupl cannot
        access files on remote systems.  Instead, nupl fingers remote
        users each time it is run and compares the users' current .plan to
        a saved copy of their .plan.

        Different systems will return different information in response
        to a finger request.  How does nupl know where, say, information
        about a user's last login time ends and that user's .plan begins?
        Since it can't guess how the system will format the finger
        response, you need to tell it which lines to ignore.

        So, for example, here is what finger might return if I tried
        to finger craig@cif.rochester.edu:

          Login: craig                         Name: Craig Harman
          Directory: /home/cif/craig           Shell: /usr/local/bin/tcsh
          On since Fri Sep 13 02:22 (EDT) on ttyp13 from somewhere
          No Mail.
          Plan:
          joel tetreault's .plan sucks ass

        The information on the line that starts with "On since" will
        change whenever the user logs in, and the "No Mail" line will
        change whenever the user receives mail, so we want to ignore
        them.  The only thing of interest is what comes after the
        line that starts with "Plan".  The format of .nuplist entries
        for remote entries is:

          username@system,word_appearing_on_the_last_line_we_will_ignore

        So, for this example, the .nuplist entry would be:

          craig@cif.rochester.edu,Plan

        Local and remote user entries can appear in any order in your
        .nuplist file.


 -------
 History
 -------

   nupl was written while I was learning the Perl scripting
   language during a semester when I was frequently logged in
   for over twelve hours a day waiting for the programs for my
   three Computer Science classes to compile or crash.

   The latest version of nupl can be found online at:

     http://www.cif.rochester.edu/~craig/nupl

   If you have any questions about using nupl, feel free to
   e-mail me at craig@cif.rochester.edu


 -------------------
 Copyright & License
 -------------------

   This software is copyright 1997-2002 by Craig Harman and is released
   under the terms of the GNU General Public License (GPL).  The full
   text of the GNU GPL can be viewed at:

     http://www.gnu.org/licenses/gpl.txt

   Use this software at your own risk.
