GREEN_COLOR='\033[0;32m'
YELLOW_COLOR='\033[0;93m'
RED_COLOR='\033[0;31m'
GRAY='\033[0;90m'
DEFAULT_COLOR='\033[0m'
echo "Welcome $(echo eval $USER) to ${GREEN_COLOR}Nuvocargo${DEFAULT_COLOR}'s Automated Dev Environment Setup Installer\n
What are we're doing to your pristine machine, you ask?\n
Sure, take a look at the tasks:\n
  • Install Brew (Package Manager) to quickly setup everything else.
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

echo "${YELLOW_COLOR}"
read -n 1 -p "Are you ready? Press 'any key' ('any key' is near that 'other key')... " waitInput
echo "${DEFAULT_COLOR}"

echo "Installing brew:\n"

# Copied block from https://brew.sh/ Added "< /dev/null" to make it non-interactive
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
# / copied block

echo "Running post-install commands...\n"

# Copied block from brew post-install instructions
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
# / copied block

if brew -v | grep -q -m1 'Homebrew'
then
    echo "${GREEN_COLOR}$(brew -v | grep -m1 'Homebrew') installed successfully${DEFAULT_COLOR}\n"
else
    echo "${RED_COLOR}Couldn't confirm that Homebrew got properly installed, closing now. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
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

echo "Installing PostgreSQL:\n"

# Copied block from https://brew.sh/
brew install postgres
# / copied block

echo "Running service...\n"

# Copied block from brew post-install instructions
brew services restart postgresql
# / copied block

if brew services list | grep -q "postgresql started"
then
    echo "${GREEN_COLOR}$(postgres --version) installed successfully and running properly${DEFAULT_COLOR}\n"
else
    echo "${RED_COLOR}Could not confirm that PostgreSQL got properly installed, closing now. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
    exit
fi

echo "Installing rbenv:\n"

# Copied block from https://brew.sh/
brew install rbenv
# / copied block

echo "Running post-install commands...\n"

# Copied block from brew post-install instructions
echo "eval \"$(rbenv init -)\"" >> ~/.zshrc
# / copied block

if rbenv -v | grep -q "rbenv"
then
    echo "${GREEN_COLOR}$(rbenv -v) installed successfully${DEFAULT_COLOR}\n"
else
    echo "${RED_COLOR}Could not confirm that rbenv got properly installed, closing now. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
    exit
fi

echo "Installing Ruby:\n"

# Copied block from https://github.com/rbenv/rbenv
rbenv install 3.0.1
# / copied block

echo "Defaulting to rbenv globally...\n"

# Copied block from https://github.com/rbenv/rbenv
rbenv global 3.0.1
# / copied block

if rbenv version | grep -q "3.0.1"
then
    echo "${GREEN_COLOR}Ruby v$(rbenv version | grep "3.0.1" | cut -f1 -d" ") installed and defaulted successfully${DEFAULT_COLOR}\n"
else
    echo "${RED_COLOR}Could not confirm that Ruby got properly installed, closing now. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
    exit
fi

echo "Installing GitHub CLI:\n"

# Copied block from https://brew.sh/
brew install gh
# / copied block

echo "Running post-install commands...\n
${RED_COLOR}This is a trust building activity, and I trust you, we can do it.
Please, oh please, follow the steps on the next script with these settings:
On the first screen, select: GitHub.com
Then select SSH as your preferred protocol
Upload your SSH public key
Login with a web browser (will ask you to copy and paste a code into the browser and give some permissions, please accept them)
Once you are done, close the tab and come back here
Finally, press Enter to finish the process.${DEFAULT_COLOR}\n"

# Copied block from https://cli.github.com/manual/
gh auth login
# / copied block

printf "Back in control of the process, doing a simple test to check for GitHub CLI installation.\n"

# TODO: This could totally be improved to validate for SSH key properly setup.
if gh auth status 2>&1 | grep -q "Logged in to github.com as"
then
  echo "${GREEN_COLOR}GitHub CLI installed and setup successfully${DEFAULT_COLOR}\n"
else
  echo "${RED_COLOR}Could not confirm that GitHub CLI got properly installed, closing now. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
fi

echo "Installing NVM:\n"

# Copied block from https://brew.sh/
brew install nvm
# / copied block

echo "Running post-install commands...\n"

# Copied block from brew post-install instructions
mkdir ~/.nvm

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
# / copied block

# Not able to test NVM proper installation, the following commented code will not work, not sure why.
# if nvm --help 2>&1 | grep -q "Node Version Manager"
# then
#     echo "${GREEN_COLOR}NVM v$(nvm --help 2>&1 | grep "Node Version Manager") installed successfully${DEFAULT_COLOR}\n"
# else
#     echo "${RED_COLOR}Could not confirm that NVM got properly installed, closing now. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
#     exit
# fi

echo "Installing Node:\n"
# Copied block from https://github.com/nvm-sh/nvm
nvm install 16
# / copied block

if node -v | grep -q "v16."
then
    echo "${GREEN_COLOR}Node $(node -v) installed successfully${DEFAULT_COLOR}\n"
else
    echo "${RED_COLOR}Could not confirm that Node got properly installed, closing now. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
    exit
fi

echo "Installing Yarn:\n"

# Copied block from https://brew.sh/
brew install yarn
# / copied block

if yarn -v | grep -q ''
then
    echo "${GREEN_COLOR}Yarn v$(yarn -v) installed successfully${DEFAULT_COLOR}\n"
else
    echo "${RED_COLOR}Could not confirm that Yarn got properly installed, closing now. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
    exit
fi

echo "Installing Heroku CLI:\n"

# Copied block from https://devcenter.heroku.com/articles/heroku-cli
brew tap heroku/brew && brew install heroku
# / copied block

if heroku -v | grep -q "heroku/"
then
    echo "${GREEN_COLOR}Heroku v$(heroku -v | cut -f1 -d' ') installed successfully${DEFAULT_COLOR}\n"
else
    echo "${RED_COLOR}Could not confirm that Heroku got properly installed, closing now. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
    exit
fi

echo "Some people like "oh-my-zsh" to improve their terminal usage experience."

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

      echo "Running post-install commands...\n"

      cat ~/.zshrc.pre-oh-my-zsh >> ~/.zshrc

      if cat ~/.zshrc | grep -m1 "oh-my-zsh"
      then
        echo "${GREEN_COLOR}$(cat ~/.zshrc | grep -m1 \"oh-my-zsh\") installed successfully${DEFAULT_COLOR}\n"
      else
        echo "${RED_COLOR}Could not confirm that oh-my-zsh got properly installed, since this is not mandatory we will continue. Please notify @Alejandro on Slack for this to be fixed.${DEFAULT_COLOR}\n"
      fi
      break
      ;;
    "Nah")
      echo "¯\_(ツ)_/¯ Welp, continuing then."
      break
      ;;
    *) echo "invalid option $REPLY";;
  esac
done

printf "${GREEN_COLOR}We are done, that was not too painful, was it? Now look for specifics on your project. Hope you have a great onboarding and adventure here at Nuvocargo!${DEFAULT_COLOR}"
