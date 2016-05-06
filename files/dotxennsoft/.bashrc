# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#PATH=$PATH:/var/www/cake_lib/cake/console:/etc/server_scripts/git:TH=$PATH:/var/www/cake_lib/cake/console:/etc/server_scripts/git:
#export PATH

PATH=$PATH:~/android-sdk-linux/tools:~/bin:/usr/local/src/p7zip_9.38.1/bin:
export PATH


# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi


function find_git_branch {
    local dir=. head
    until [ "$dir" -ef / ]; do
        if [ -f "$dir/.git/HEAD" ]; then
		UNTRACKED=$(git ls-files --others --exclude-standard | wc -l | sed -e 's/^ *//' -e 's/ *$//')
		MOD=$(git ls-files -m | wc -l | sed -e 's/^ *//' -e 's/ *$//')
		TOTAL_ALTERED=$(($MOD + $UNTRACKED))
            head=$(< "$dir/.git/HEAD")
            if [[ $head == ref:\ refs/heads/* ]]; then
                git_branch="[${head#*/*/}]"
            elif [[ $head != '' ]]; then
                git_branch='(detached)'
#		MOD=`git ls-files --others --exclude-standard | wc -l`
#		UNTRACKED=`git ls-files -m | wc -l`
            else
                git_branch='(unknown)'
#		MOD=`git ls-files --others --exclude-standard | wc -l`
#		UNTRACKED=`git ls-files -m | wc -l`
            fi
	    if [ $TOTAL_ALTERED -gt 0 ]; then
		git_branch=" *$git_branch[$MOD][$UNTRACKED]"
	    else
		git_branch=" $git_branch "
	    fi
            return
        fi
        dir="../$dir"
    done
    git_branch=''
    MOD=''
    UNTRACKED=''

}

PROMPT_COMMAND="find_git_branch; $PROMPT_COMMAND"


green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
normal=$'\e[m'
bldwht=$'\e[1;37m'

export wordpress_site_url="adam.xen"
export wordpress_site_name="Adam blog"
export wordpress_site_email="aholsinger@xensoft.com"
export wordpress_site_user="aholsinger"
export wordpress_site_password="insight21"

PS1="\[$green\]\u@\h\[$blue\] \w\[$bldwht\]\$git_branch\[$green\]\$\[$normal\] "
export PATH

alias use_fpm="sudo service hhvm stop && sudo service php5-fpm start"
alias use_hhvm="sudo service php5-fpm stop && sudo service hhvm start"
alias x="xflock4"
alias clearcache="/var/www/html/hawk/eagle/scripts/clearcache.sh hawk"
alias phpunitx="XDEBUG_CONFIG='idekey=PHPSTORM' PHP_IDE_CONFIG='serverName=adam.xen' /var/www/html/hawk/eagle/selenium/vendor/phpunit/phpunit/phpunit"
alias phpx="XDEBUG_CONFIG='idekey=PHPSTORM' /usr/bin/php"
alias phpm="XDEBUG_CONFIG='idekey=PHPSTORM' /usr/bin/php"
alias phoenix="cd /var/www/html/phoenix"
alias hawk="cd /var/www/html/hawk"
alias hawkeagle="cd /var/www/html/hawk_eagle"
alias hawklog="cd /var/www/html/magento/var/log"
alias modules="cd /var/www/html/hawk/magento/app/code/local/Xennsoft"
alias xenntemplate="cd /var/www/html/hawk/magento/app/design/frontend/base/default/template/xennsoft"
alias automate="cd /var/www/html/hawk/eagle/selenium"
alias template="cde /var/www/html/hawk/magento/app/design/frontend/base/default/template"
alias i="ibus restart"
alias phpstorm="../dev/n98-magerun.phar dev:ide:phpstorm:meta"
alias fixBaseUrl="php /var/www/html/hawk/dev/scripts/fixBaseUrl.php --base https://adam.xen/store/"
alias sync-eagle='rsync -a --progress -e "ssh -p 10001" aholsinger@xennsoft.com:/var/www/html/xennsoft.com/eagle/var/modules/ /var/www/html/hawk_eagle/eagle/var/modules/'
alias ngerr="sudo tail -f /var/log/nginx/error.log"
alias hhvmerr="sudo tail -f /var/log/hhvm/error.log"
alias process_queue="sudo  /usr/bin/php /var/www/html/hawk_eagle/eagle/bin/Billing_Cron ProcessQueue"
alias process_queuex="sudo XDEBUG_CONFIG='idekey=PHPSTORM' /usr/bin/php /var/www/html/hawk_eagle/eagle/bin/Billing_Cron ProcessQueue"
alias process_buildx="sudo XDEBUG_CONFIG='idekey=PHPSTORM' /usr/bin/php /var/www/html/hawk_eagle/eagle/bin/Billing_Cron ProcessBuild"
alias process_build="sudo  /usr/bin/php /var/www/html/hawk_eagle/eagle/bin/Billing_Cron ProcessBuild"
alias site_available="php Billing_Cron SiteAvailable";
alias site_availablex="XDEBUG_CONFIG='idekey=PHPSTORM' /usr/bin/php /var/www/html/hawk_eagle/eagle/bin/Billing_Cron SiteAvailable";
alias ir="ibus restart"
alias tl="/var/www/html/hawk/dev/TicketCli/bin/ticket.php timer:list"
alias il="/var/www/html/hawk/dev/TicketCli/bin/ticket.php -ad issue:list"
alias ild="/var/www/html/hawk/dev/TicketCli/bin/ticket.php issue:list"
alias ig="/var/www/html/hawk/dev/TicketCli/bin/ticket.php issue:get"
alias cwc="php /var/www/html/hawk/wordpress/cache/ cleanAll.php"
alias delete_mail_queue="sudo postsuper -d ALL"
alias see_queue="sudo postqueue -p"
alias startw="sudo supervisorctl start laravel-worker:*"
alias stopw="sudo supervisorctl stop laravel-worker:*"
alias djobs="/usr/bin/php /var/www/html/phoenix/artisan jobs:delete --a"

function see_jobs {
       /usr/bin/php /var/www/html/phoenix/artisan jobs:view -c "$@"	
}

function tlist {
	timer timer:list 
}
function tlog {
	timer timer:log $1
}

function t+ {
	timer timer:start $1
}

function t- {
	timer timer:stop $1
}

function timer {
	/var/www/html/hawk/dev/TicketCli/bin/ticket.php "$@"	
}

function tools {
	/var/www/html/hawk/dev/DevTools/src/app "$@"
}

function rchmod {
	tools File:chmod "$@"
}

function rscp {
	tools File:copy "$@"
}

function r {
	tools remote:run "$@"
}

function cookbook_latest {
	knife cookbook site show $1 | grep latest_version
}

function see_jobs {
	/usr/bin/php /var/www/html/phoenix/artisan jobs:view -c "$@"
}

function chef_bootstrap {
	berks upload xennsoft --force	
	knife bootstrap $1 --ssh-user root --sudo --identity-file ~/.ssh/id_rsa --node-name $2 --run-list recipe\[$3\] 
}

function chef_checkin_root {
	berks upload xennsoft --force	
	knife ssh $1 'sudo chef-client' --manual-list --ssh-user root --identity-file ~/.ssh/eagle -p 10001
}

function chef_checkin {
	berks upload xennsoft --force	
	knife ssh $1 'sudo chef-client' --manual-list --ssh-user eagle --identity-file ~/.ssh/eagle
}

function chef_node_delete {
	knife node delete --yes $1 && knife client delete --yes $1
}

function cq {
	knife search "name:$1*"
}


current_remote="origin"
function current_remote() {
	echo $current_remote
}

function paratest() {
	/var/www/html/hawk/eagle/selenium/vendor/bin/paratest -p 2 -f --phpunit=/var/www/html/hawk/eagle/selenium/vendor/bin/phpunit "$@"
}

function gu {
	echo "git fetch $current_remote --tags"
	git fetch $current_remote --tags
	currentBranch=$(git rev-parse --abbrev-ref HEAD)
	echo "git pull $current_remote  $currentBranch"
	git pull $current_remote $currentBranch 
	clearcache
} 

function gpo {
	currentBranch=$(git rev-parse --abbrev-ref HEAD)
	echo "git push $current_remote $currentBranch"
	git push $current_remote $currentBranch
	if [ $? -ne 0 ]; then
		gu
		git push $current_remote $currentBranch
	fi
}

function dtags {
	echo "git push $current_remote --tags --dry-run"
	git push $current_remote --tags --dry-run
}


function tags {
	echo "git push $current_remote --tags "
	git push $current_remote --tags 
}

function sdv {
	if [[ $# -ne 3 ]]; then
		echo "Wrong count of arguments... example 'sdv 10 11 checkout'"
		return
	fi
        prevVersion=$(tp $3 -s $1)
	echo $prevVersion;
	if [[ -z `tag_exists $prevVersion` ]]; then
		echo "Tag $prevVersion does not exist"
		return;
	fi

	nextVersion=$(tp $3 -s $2)
	if [[ -z `tag_exists $nextVersion` ]]; then
		echo "Tag $nextVersion does not exist"
		return;
	fi

	echo "Showing diff of $prevVersion to $nextVersion"
    	read -p "Continue (y/n)?" should_show
	if [ "$should_show" == "y" ]; then
		git difftool -d $prevVersion $nextVersion
	fi
}


function tag_exists {
	echo "git tag --list | grep $1"
	git tag --list | grep $1
}

function s {
	ssh -p 10001 eagle@$1.xennbox.es
}

function sd {
	ssh -p 10001 -i ~/.ssh/pidgin_id_rsa pidgin@$1-beta-wp.xennbox.com
}

function sh {
	ssh -p 10001 $1
}

function dodo_assets {
	local_dir="/var/www/html/dodo_uploads/$1"
	if [ ! -d $local_dir ]; then
		mkdir -p $local_dir
	fi
	rsync -rlDz --progress -e "ssh -p 10001" pidgin@$1-beta-wp.xennbox.com:/var/www/html/$1-beta-wp.xennbox.com/wordpress/wp-content/uploads/* /var/www/html/dodo_uploads/$1/
	wordpress_dir="/var/www/html/dodo/wordpress/wp-content/uploads";
	if [ ! -L $wordpress_dir ] && [ -d $wordpress_dir ]; then
		rm -rf $wordpress_dir;
	fi

	if [ -L $wordpress_dir ]; then
		unlink $wordpress_dir;
	fi
	ln -s $local_dir $wordpress_dir	
}

HAWKDIR="/var/www/html/hawk"
function annotate {
   cd $HAWKDIR/magento && php ../dev/n98-magerun.phar dev:code:model:method $1 && cd -
} 

function t {
	/var/www/html/hawk/dev/TicketCli/bin/ticket.php
}


source /var/www/html/hawk/dev/DevTools/src/Tagger/aliases
source /var/www/html/hawk/dev/xenn_rc
source /var/www/html/phoenix/phoenix_rc

