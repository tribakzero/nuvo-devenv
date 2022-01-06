GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
NORMAL=$(tput sgr0)
ERROR_ADVICE="Please notify @Alejandro on Slack for this to be fixed."
printf "%40s\n" "Welcome $USER to ${GREEN}Nuvocargo${NORMAL}'s Automated Dev Environment Setup Installer\n
What are we're doing to your pristine machine, you ask?\n
Sure, take a look at the tasks:\n
  - Install Rosetta (For M1 compatibility, it validates the right architecture)
  • Install Brew (Package Manager to quickly setup everything else)
  • Install an IDE (optional)
  • Install PostgreSQL and run the service
  • Install rbenv
  • Install Ruby
  • Install GitHub CLI
  • Install NVM
  • Install Node
  • Install Yarn
  • Install Heroku CLI
  • Install oh-my-zsh (optional)\n"

printf "%40s\n" "${YELLOW}"
read -r -n 1 -p "Are you ready? Press 'any key' ('any key' is near that 'other key')... "
printf "%40s\n" "${NORMAL}"

if [[ $(uname -p) == 'arm' ]]; then
  printf "Check found M1 Processor, installing Rosetta 2"

  # Copied block from https://blog.kandji.io/what-mac-admins-need-to-know-about-rosetta-2
  softwareupdate --install-rosetta --agree-to-license
  # / copied block
fi

printf "Installing brew:\n"

# Copied block from https://brew.sh/ Added "< /dev/null" to make it non-interactive
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
# / copied block

printf "Running post-install commands...\n"

# Copied block from brew post-install instructions
echo "eval \"$(/opt/homebrew/bin/brew shellenv)\"" >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
# / copied block

if brew -v | grep -q -m1 'Homebrew'
then
    printf "%40s\n" "${GREEN}$(brew -v | grep -m1 'Homebrew') installed successfully${NORMAL}\n"
else
    printf "%40s\n" "${RED}Couldn't confirm that Homebrew got properly installed, closing now. $ERROR_ADVICE${NORMAL}\n"
    exit
fi

echo "There are a lot of IDEs, here we have some for you to pick."

PS3="Would you like one of these? "
options=("Visual Studio Code" "Webstorm" "RubyMine" "Atom" "None")
select option in "${options[@]}"
do
  case $option in
    "Visual Studio Code")
      echo "Installing VSCode"

      # Copied block from https://brew.sh/
      brew install --cask visual-studio-code
      # / copied block

      break
      ;;
    "Webstorm")
      echo "Installing Webstorm"

      # Copied block from https://brew.sh/
      brew install --cask webstorm
      # / copied block

      break
      ;;
    "RubyMine")
      echo "Installing RubyMine"

      # Copied block from https://brew.sh/
      brew install --cask rubymine
      # / copied block

      break
      ;;
    "Atom")
      echo "Installing Atom"

      # Copied block from https://brew.sh/
      brew install --cask atom
      # / copied block

      break
      ;;
    "None")
      echo "Sure, we will move forward then"
      break
      ;;
    *) echo "invalid option $REPLY";;
  esac
done

printf "Installing PostgreSQL:\n"

# Copied block from https://brew.sh/
brew install postgres
# / copied block

printf "Running service...\n"

# Copied block from brew post-install instructions
brew services restart postgresql
# / copied block

if brew services list | grep -q "postgresql started"
then
    printf "%40s\n" "${GREEN}$(postgres --version) installed successfully and running properly${NORMAL}\n"
else
    printf "%40s\n" "${RED}Could not confirm that PostgreSQL got properly installed, closing now. $ERROR_ADVICE${NORMAL}\n"
    exit
fi

printf "Installing rbenv:\n"

# Copied block from https://brew.sh/
brew install rbenv
# / copied block

printf "Running post-install commands...\n"

# Copied block from brew post-install instructions
printf "%40s\n" "eval \"$(rbenv init -)\"" >> ~/.zshrc
# / copied block

if rbenv -v | grep -q "rbenv"
then
    printf "%40s\n" "${GREEN}$(rbenv -v) installed successfully${NORMAL}\n"
else
    printf "%40s\n" "${RED}Could not confirm that rbenv got properly installed, closing now. $ERROR_ADVICE${NORMAL}\n"
    exit
fi

printf "Installing Ruby:\n"

# Copied block from https://github.com/rbenv/rbenv
rbenv install 3.0.1
# / copied block

printf "Defaulting to rbenv globally...\n"

# Copied block from https://github.com/rbenv/rbenv
rbenv global 3.0.1
# / copied block

if rbenv version | grep -q "3.0.1"
then
    printf "%40s\n" "${GREEN}Ruby v$(rbenv version | grep "3.0.1" | cut -f1 -d" ") installed and defaulted successfully${NORMAL}\n"
else
    printf "%40s\n" "${RED}Could not confirm that Ruby got properly installed, closing now. $ERROR_ADVICE${NORMAL}\n"
    exit
fi

printf "Installing GitHub CLI:\n"

# Copied block from https://brew.sh/
brew install gh
# / copied block

printf "%40s\n" "Running post-install commands...\n
${RED}This is a trust building activity, and I trust you, we can do it.
Please, oh please, follow the steps on the next script with these settings:
On the first screen, select: GitHub.com
Then select SSH as your preferred protocol
Upload your SSH public key
Login with a web browser (will ask you to copy and paste a code into the browser and give some permissions, please accept them)
Once you are done, close the tab and come back here
Finally, press Enter to finish the process.${NORMAL}\n"

# Copied block from https://cli.github.com/manual/
gh auth login
# / copied block

printf "Back in control of the process, doing a simple test to check for GitHub CLI installation.\n"

# TODO: This could totally be improved to validate for SSH key properly setup.
if gh auth status 2>&1 | grep -q "Logged in to github.com as"
then
  printf "%40s\n" "${GREEN}GitHub CLI installed and setup successfully${NORMAL}\n"
else
  printf "%40s\n" "${RED}Could not confirm that GitHub CLI got properly installed, closing now. $ERROR_ADVICE${NORMAL}\n"
fi

printf "Installing NVM:\n"

# Copied block from https://brew.sh/
brew install nvm
# / copied block

printf "Running post-install commands...\n"

# Copied block from brew post-install instructions
mkdir ~/.nvm

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
# / copied block

# Not able to test NVM proper installation, the following commented code will not work, not sure why.
# if nvm --help 2>&1 | grep -q "Node Version Manager"
# then
#     echo "${GREEN}NVM v$(nvm --help 2>&1 | grep "Node Version Manager") installed successfully${NORMAL}\n"
# else
#     echo "${RED}Could not confirm that NVM got properly installed, closing now. $ERROR_ADVICE${NORMAL}\n"
#     exit
# fi

printf "Installing Node:\n"
# Copied block from https://github.com/nvm-sh/nvm
nvm install 16
# / copied block

if node -v | grep -q "v16."
then
    printf "%40s\n" "${GREEN}Node $(node -v) installed successfully${NORMAL}\n"
else
    printf "%40s\n" "${RED}Could not confirm that Node got properly installed, closing now. $ERROR_ADVICE${NORMAL}\n"
    exit
fi

printf "Installing Yarn:\n"

# Copied block from https://brew.sh/
brew install yarn
# / copied block

if yarn -v | grep -q ''
then
    printf "%40s\n" "${GREEN}Yarn v$(yarn -v) installed successfully${NORMAL}\n"
else
    printf "%40s\n" "${RED}Could not confirm that Yarn got properly installed, closing now. $ERROR_ADVICE${NORMAL}\n"
    exit
fi

printf "Installing Heroku CLI:\n"

# Copied block from https://devcenter.heroku.com/articles/heroku-cli
brew tap heroku/brew && brew install heroku
# / copied block

if heroku -v | grep -q "heroku/"
then
    printf "%40s\n" "${GREEN}Heroku v$(heroku -v | cut -f2 -d'/' | cut -f1 -d' ') installed successfully${NORMAL}\n"
else
    printf "%40s\n" "${RED}Could not confirm that Heroku got properly installed, closing now. $ERROR_ADVICE${NORMAL}\n"
    exit
fi

printf "Some people like 'oh-my-zsh' to improve their terminal usage experience."

PS3="Would you like to install it? "
options=("Sure" "Nah")
select option in "${options[@]}"
do
  case $option in
    "Sure")
      echo "Ok, installing it."
      # Copied block from https://ohmyz.sh/
      sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      # / copied block

      printf "Running post-install commands...\n"

      printf "\n\n# Copied from the original .zshrc\n" >> ~/.zshrc
      cat ~/.zshrc.pre-oh-my-zsh >> ~/.zshrc

      if grep -m1 'oh-my-zsh' < ~/.zshrc
      then
        printf "%40s\n" "${GREEN}$(grep -m1 'oh-my-zsh' < ~/.zshrc) installed successfully${NORMAL}\n"
      else
        printf "%40s\n" "${RED}Could not confirm that oh-my-zsh got properly installed, since this is not mandatory we will continue. $ERROR_ADVICE${NORMAL}\n"
      fi
      break
      ;;
    "Nah")
      printf "¯\_(ツ)_/¯ Welp, continuing then."
      break
      ;;
    *) printf "%40s\n" "invalid option $REPLY";;
  esac
done

printf "%40s\n" "${GREEN}We are done, that was not too painful, was it? Now look for specifics on your project. Hope you have a great onboarding and adventure here at Nuvocargo!${NORMAL}"
