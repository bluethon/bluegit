Pipenv Note
===========

CMD
---

    pipenv
        --rm                    # 移除虚拟环境

``` sh
# install(recommended)
brew install pipenv
# or
pip3 install --user pipenv

# add to .zshrc(command not found)
BASE=`python3 -m site --user-base`
echo export PATH="$BASE/bin:$PATH" >> ~/.zshrc

# active
pipenv shell

# install from requirements.txt
pipenv install <package>
# install in basic and dev packages
pipenv install -d
pipenv install -r requirements.txt


pipenv lock -r > requirements.txt
pipenv lock -rd > requirements-dev.txt

pipenv update
# equal to
pipenv lock
pipenv sync

# remove and delete from Pipfile
pipenv uninstall <package>
# remove all pack in [packages]
pipenv uninstall --all
```
