#!/usr/local/bin/perl

# ===[ nupl - the nu plan script ]=======================================
#
#  Author:         Craig Harman      (craig@cif.rochester.edu)
#  Created:        Sometime in 1997
#  Last modified:  8 April 2002
#  License:        GNU General Public License (GPL) - see below
#
#
#  -----------
#  What is it?
#  -----------
#
#    nupl is a Perl script designed to check for new plans.  If you
#    finger a group of friends frequently, and their .plan files
#    change frequently, then you may find nupl useful.
#
#    To use nupl, you must create a text file with a list of usernames.
#    nupl will look at the .plan file of each username that you give
#    it, and then display all of the .plan's that have changes since
#    the last time you ran nupl.  nupl can check .plan's on both local
#    and remote email servers.
#
#
#  ------------------
#  Quick Instructions
#  ------------------
#
#    [1]  Get your hands on a copy of nupl
#
#    [2]  At your command prompt, type:
#
#           perl nupl install
#
#    [3]  Create a file called .nuplist in your home directory using 
#         your favorite text editor.  Each line of the file should 
#         contain the username of someone you want to finger.  For
#         example, a .nuplist file could contain the lines:
#
#           craig
#           aaron
#           pr005f@mail.rochester.edu
#
#         This file tells nupl to finger the users 'craig' and 'aaron'
#         on the local system, and the user 'pr005f' on the remote 
#         system 'mail.rochester.edu'.
#
#    [4]  Run nupl whenever you want to check your friends' .plans
#
#
#  ---------------------
#  Detailed Instructions
#  ---------------------
#
#    I have tried to make as few assumptions about your familiarity with
#    UNIX as possible.  I do assume that you are familiar with a text
#    editor, such as joe or pico.  pico is the default editor for Pine,
#    so if you can compose email with Pine, you can use pico.
#
#    I also refer to your 'home directory' in the following instructions.
#    Your home directory is the directory that you start in when you 
#    login to mail.  The ~ (tilde) character is a special UNIX alias
#    for a home directory.  You can always get to your home directory
#    by typing
#
#       cd ~
#
#    at a command prompt.
#
#    [1]  Copy nupl (this file) to your home directory.  If nupl was sent to
#         you as an email attachment, then save the attachment to your home
#         directory.  If you know one of your friends has nupl installed
#         on your email server, you should be able to copy it your home
#         directory using something like this:
#
#            cp ~craig/nupl ~
#
#    [2]  Once you have a copy of nupl in your home directory, you can
#         install it by typing:
#
#            perl nupl install
#
#         If the installation is successful, nupl will print instructions
#         about how to use it.
#
#    [3]  The next step is to create a file called .nuplist in your
#         home directory using your favorite text editor.  To do this
#         using pico, you would type
#
#            pico ~/.nuplist
#
#         at a command prompt.  
#
#         The .nuplist file should have one username on each line.  
#         The user you want to finger can have an account on the 
#         machine that you are running the nupl script on (local 
#         user) or an account on another machine (remote user).  
#         Entries in the .nuplist file will need to have a different
#         form for local users than for remote users.
#
#         LOCAL USERS:
#
#         A sample .nuplist file containing local user entries might
#         look something like this:
#
#            ch001e
#            cc012c
#            ep001b
#
#
#         REMOTE USERS
#
#         nupl determines if a local user's .plan has changed by checking
#         the time that the .plan file was last modified.  This approach
#         will not work for users on remote systems since nupl cannot
#         access files on remote systems.  Instead, nupl fingers remote
#         users each time it is run and compares the users' current .plan to
#         a saved copy of their .plan.
#
#         Different systems will return different information in response
#         to a finger request.  How does nupl know where, say, information
#         about a user's last login time ends and that user's .plan begins?
#         Since it can't guess how the system will format the finger
#         response, you need to tell it which lines to ignore.
#
#         So, for example, here is what finger might return if I tried
#         to finger craig@cif.rochester.edu:
#
#           Login: craig                         Name: Craig Harman
#           Directory: /home/cif/craig           Shell: /usr/local/bin/tcsh
#           On since Fri Sep 13 02:22 (EDT) on ttyp13 from somewhere
#           No Mail.
#           Plan:
#           joel tetreault's .plan sucks ass
#
#         The information on the line that starts with "On since" will 
#         change whenever the user logs in, and the "No Mail" line will
#         change whenever the user receives mail, so we want to ignore
#         them.  The only thing of interest is what comes after the
#         line that starts with "Plan".  The format of .nuplist entries
#         for remote entries is:
#
#           username@system,word_appearing_on_the_last_line_we_will_ignore
#
#         So, for this example, the .nuplist entry would be:
#
#           craig@cif.rochester.edu,Plan
#
#         Local and remote user entries can appear in any order in your
#         .nuplist file.
#
#
#  -------
#  History
#  -------
#
#    nupl was written while I was learning the Perl scripting
#    language during a semester when I was frequently logged in
#    for over twelve hours a day waiting for the programs for my
#    three Computer Science classes to compile or crash.
#
#    The latest version of nupl can be found online at:
#
#      http://www.cif.rochester.edu/~craig/nupl
#
#    If you have any questions about using nupl, feel free to
#    e-mail me at craig@cif.rochester.edu
#
#
#  -------------------
#  Copyright & License
#  -------------------
#
#    This software is copyright 1997-2002 by Craig Harman and is released
#    under the terms of the GNU General Public License (GPL).  The full
#    text of the GNU GPL can be viewed at:
#
#      http://www.gnu.org/licenses/gpl.txt
# 
#    Use this software at your own risk.
#
#
# ===[ nupl ]============================================================


#
#  Everything below is part of the Perl script.  If you're not
#  familiar with Perl, it will likely make little to no sense.
#



# --- If the user runs the script with the 'install' argument:
#   -  ~ Use chmod to make nupl executable
#   -  ~ Rewrite the first line of script to point to the
#   -     location of Perl on this machine
#   -  ~ Print execution instructions
#   -
if ((lc $ARGV[0]) =~ /install/) {

    # --- Use the 'which' command to find the Perl interpreter.
    #   - 'which' is implemented as a shell command in 'sh', so
    #   - this should be portable on UNIX systems, but will most
    #   - assuredly break on a Win32 system.
    $perl_location = `which perl`;

    # --- Strip newline from string
    chomp($perl_location);

    if (not -e $perl_location) {
	die "Installation failed!" . 
	    "I am unable to find the Perl interpreter.\n" .
	    "You wouldn't be able to see this error message if Perl wasn't\n" .
	    "installed around here somewhere, though.  Now might be a good\n" .
	    "time to ask your sysadmin for help.\n";
    }


    # ---  Rewrite script  ---

    $NUPL_OLD = "<nupl";
    $NUPL_NEW = ">newnupl";

    open NUPL_OLD or die "Can't open $NUPL_OLD: $!\n";
    open NUPL_NEW or die "Can't open $NUPL_NEW: $!\n";

    $first_line = <NUPL_OLD>;

    # --- Check for shebang (#!) on the first line of the original script
    if ($first_line =~ /\#\!/) {
	# --- Shebang found.  Ignore first line of original script, write
	#   - location of Perl interpreter to new script.
	print NUPL_NEW "#!$perl_location\n";
    }
    else {
	# --- Shebang not found.  Write location of Perl interpreter to
	#   - new script AND copy first line of original script to the
	#   - new script.
	print NUPL_NEW "#!$perl_location\n";
	print NUPL_NEW $first_line;
    }

    # --- Copy the rest of the original script to the new script
    while (<NUPL_OLD>) {
	print NUPL_NEW $_;
    }
    
    close NUPL_NEW;
    close NUPL_OLD;

    # --- Replace the old version of the script with the new
    unlink "nupl";
    rename "newnupl", "nupl";


    # --- Make the current Perl script (nupl) executable
    chmod 0744, $0;


    # --- Check to see if '.' is part of the user's path, and
    #   - print appropriate usage instructions based on results.
    if (not $ENV{PATH} =~ /\./) {
	print
	    "The current directory (.) is not in your path.\n" .
	    "To start the nupl script, you will need to type:\n" .
	    "\n\t./nupl\n\n" .
	    "at your command prompt.\n";
    }
    else {
	print
	    "To start the nupl script, just type:\n" .
	    "\n\tnupl\n\n" .
	    "at your command prompt.\n";
    }


    exit;
}



# --- Packages

use Cwd;           # current working directory package


# --- Save current directory
$original_dir = cwd();

# --- Change to home directory
$HOMEDIR = $ENV{"HOME"} || $ENV{"LOGDIR"} || (getpwuid($<))[7];
chdir($HOMEDIR) or
  die "Can't change to home directory: $!\n";



# --- Read in the list of .plans to check on ---

$PLANLIST = "<.nuplist";

if (not open PLANLIST) {
    print
	"Warning- The .nuplist file could not be opened: $!\n\n" .
	"If this is the first time that you have run nupl, then this\n" .
	"is perfectly normal behavior. You will need to create a file\n" .
	"called .nuplist with your favorite text editor. If you read\n" .
	"your email using Pine, then you can create the file with Pine's\n" .
	"text editor (Pico) by issuing the follow command:\n\n" .
	"\tpico .nuplist\n\n" .
	"Each line of the file should contain the account name of a person\n" .
	"that you want nupl to finger. The account names can be local\n" .
	"accounts (username) or remote accounts (username\@college.edu).\n" .
	"For example, a .nuplist file could contain the following lines:\n\n" .
	"\tcraig\n\taaron\n\tpr005f\@mail.rochester.edu\n\n" .
	"Once you have created a .nuplist file, you can use nupl whenever\n" .
	"you want to check for new .plan's.\n\n";

    exit;
}

while (<PLANLIST>) {                     # --- Read line from file

    # --- Split current comma delimited line into seperate fields
    $line = $_;
    chomp $line;
    @fields = split /\s*,\s*/, $line;

    # --- Create an entry in the hashtable for each non-blank line
    if ($fields[0]) {
	$plan_hash{$fields[0]} = "exists";
    }
}

close PLANLIST;



# --- Read in list of times that .plans last changed ---

$NEWPLIST = "<.tmp_nuplist";

if (open NEWPLIST) {
    while (<NEWPLIST>) {
	# --- Each line of the NEWPLIST file should start with a username.
	#   - This username can be a local username (i.e., "craig") or
	#   - remote username (i.e., "craig@cif.rochester.edu"). 
	#   -
	#   - Local usernames should be followed by a comma and then a
	#   - timestamp (obtained from the stat function) indicating 
	#   - when the file was last modified.
	#   -
	#   - Remote usernames can be followed by a comma and then a
	#   - keyword.

	# --- Split current comma delimited line into seperate fields
	$line = $_;
	chomp $line;
	@fields = split /\s*,\s*/, $line;

	# --- If a second field (timestamp or keyword) exists, assign it to
	#   - the hash value associated with the first field (username).
	if ($plan_hash{$fields[0]}) {
	    if ($fields[1]) {
		$plan_hash{$fields[0]} = $fields[1];
	    }
	}
    }
} 
else { # --- Could not open NEWPLIST file
    # --- If the open call fails than the NEWPLIST files does
    #   - does not exist yet, which is expected behavior the
    #   - first time that the script is run.
}

close NEWPLIST;



# --- Check to see which .plans have changed ---

$NEWPLANS = ">.nuplans";
$NEWPLIST = ">.tmp_nuplist";

open NEWPLIST or die "Error - Can't open $NEWPLIST: $!\n";

foreach $username (sort keys %plan_hash) {

    # --- Check if user's name contains an '@' symbol 
    if ($username =~ /\@/) {
	# --- ...then the user has an account on a remote system

	# --- keyword appearing in last line to ignore
	$keyword = $plan_hash{$username};

	# --- The default keyword is "Plan"
	if ($keyword =~ "exists") {
	    $keyword = "Plan";
	}

	# --- The .plan's of remote users are dumped into the .nupl directory.
	#   - Create the directory if it does not already exist.
	if (-e ".nupl") {
	    if (not -d ".nupl") {
		print "The file '.nupl' should be a directory.\nPlease " .
		    "type\n\n\trm .nupl\n\n" .
		    "at the command prompt to remove the file.\n";
	    }
	}
	else {
	    mkdir ".nupl", 0700;
	}

	# --- Finger the user
	$theplan = `finger -l -m $username`;

	if (-e ".nupl/$username") {
	    @lines = split /\n/, $theplan;

	    # --- Skip over the first few lines of the new plan until
	    #   - we encounter $keyword
	    for (($line = shift @lines); 
		 not $line =~ /$keyword/ and scalar @lines > 0;
		 ($line = shift @lines)) 
	    {
	    }

	    # --- Check if the keyword was found in the .plan,
	    #   - including the last line that was examined
	    if (scalar @lines == 0 and not $line =~ /$keyword/) {
		# --- The keyword was not found in the plan
		print
		    "Warning:\n\tThe word '$keyword' was not found in " .
		    $username . "'s .plan\n\n\t" .
		    "The server may be down, or you may need to search for\n" .
		    "\tsome word other than '$keyword' in this .plan\n\n" .
		    "\tType 'more nupl' for more information.\n";
	    }
	    else {
		# --- The keyword was found in the .plan

		# --- Open file containing plan from the last time we
		#   - fingered this user
		$OLDPLAN = "<.nupl/$username";
		open OLDPLAN or die "Can't open $OLDPLAN: $!\n";

		# --- Skip over all the lines before the keyword appears
		while ($line = <OLDPLAN> and not $line =~ /$keyword/) 
		{
		}

		$theplan_changed = 0;

		while (<OLDPLAN>) {
		    # --- Compare the line from the stored .plan with the 
		    #   - corresponding line from the current .plan
		    $oldline = $_;
		    chomp $oldline;
		    $newline = shift @lines;

		    if ($oldline ne $newline) {
			$theplan_changed = 1;
		    }
		}
		close OLDPLAN;

		# --- If there are any lines left in the new .plan, then
		#   - the user has appended info to their .plan, and thus
		#   - their .plan has changed
		if (scalar @lines != 0) {
		    $theplan_changed = 1;
		}

		if ($theplan_changed == 1) {
		    # --- The (portion of interest of the) user's plan has
		    #   - changed so we can display it.
		    if ($plans_changed == 0) {
			open NEWPLANS or die "Can't create $NEWPLANS: $!\n";
			print NEWPLANS ">" . "-" x 78 . "<\n";
			$plans_changed = 1;
		    }
		    print NEWPLANS $theplan . "\n>" . "-" x 78 . "<\n";

		    # --- Write the user's new .plan to the file with the 
		    #   - user's name in the .nupl directory.
		    $APLAN = ">.nupl/$username";
		    open APLAN or die "Can't open $APLAN: $!\n";
		    print APLAN $theplan;
		    close APLAN;
		}
	    } 
	}
	else {
	    # --- This user has not been fingered before, so we will
	    #   - always display their .plan
	    if ($plans_changed == 0) {
		open NEWPLANS or die "Can't create $NEWPLANS: $!\n";
		print NEWPLANS ">" . "-" x 78 . "<\n";
		$plans_changed = 1;
	    }
	    print NEWPLANS $theplan . "\n>" . "-" x 78 . "<\n";

	    # --- Save the .plan to a file with the user's name in 
	    #   - the .nupl directory.
	    $APLAN = ">.nupl/$username";
	    open APLAN or die "Can't open $APLAN: $!\n";
	    print APLAN $theplan;
	    close APLAN;
	    
	    $plans_changed = 1;
	}

	print NEWPLIST "$username,$keyword\n";
    }
    else {  # not $username =~ /\@/
	# --- ...then the user has an account on the local system 

	$timestamp = $plan_hash{$username};

	# --- If this is the first time a user has been fingered,
	#   - then we set the timestamp to a bogus value.
	if ($timestamp =~ "exists") {
	    $timestamp = 1;
	}

	# --- Use (POSIX compliant) getpwnam system call to retrieve
	#   - location of user's home directory from /etc/passwd.
	#   -
	# --- Programming Perl suggests using the getpwent system call
	#   - for repeated directory retrievals.  But on Uhura, at least,
	#   - /etc/passwd is ~500k.  Repeated calls to getpwnam should
	#   - be less expensive than loading /etc/passwd into program
	#   - memory using getpwent since /etc/passwd is likely to be
	#   - cached.
	$fname = (getpwnam $username)[7] . "\/" . ".plan";

	$lastmod = (stat $fname)[9];

	print NEWPLIST "$username,$lastmod\n";

	# --- Check if .plan file modified since last this script was run
	if ($lastmod > $timestamp) {
	    if ($plans_changed == 0) {
		open NEWPLANS or die "Can't create $NEWPLANS: $!\n";
		print NEWPLANS ">" . "-" x 78 . "<\n";
		$plans_changed = 1;
	    }

	    # --- If the .plan file was modified, finger that user
	    print NEWPLANS `finger -l -m $username` . "\n>" . 
		"-" x 78 . "<\n";
	}
    }
}

close NEWPLIST;


# ---  The Graceful Exit  ---

if ($plans_changed == 1) {
  close NEWPLANS;
}

# --- Restrict read access on the list of usernames and the current
#   - list of plans.  Why should other people know whose plans you're
#   - reading?
chmod 0600, ".nuplist";
chmod 0600, ".nuplans";

chdir($original_dir) or die "Can't change to original directory: $!\n";

# --- Display the new plan files 
if ($plans_changed == 1) {
    # --- If the PAGER environmental variable is set, use that
    if ($ENV{PAGER}) {
	exec "$ENV{PAGER} $HOMEDIR/.nuplans";
    }

    # --- Otherwise, try to use the 'less' pager
    else {
	exec "less $HOMEDIR/.nuplans";
    }
}

