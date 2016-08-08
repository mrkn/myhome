python_versions = %w[
  2.7.11
  3.5.1
]

python_global_version = '3.5.1'

package 'pyenv'
package 'pyenv-virtualenv'

[*python_versions, python_global_version].uniq.each do |version|
  execute "pyenv install #{version}" do
    command %[eval "$(pyenv init -)"; PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install #{version}]
    not_if  %[eval "$(pyenv init -)"; pyenv versions | grep #{version}]
  end

  execute "python -m pip install --upgrade pip" do
    command %[PYENV_VERSION=#{version} python -m pip install --upgrade pip]
  end
end

execute "pyenv global #{python_global_version}" do
  command %[eval "$(pyenv init -)"; pyenv global #{python_global_version}]
  not_if  %[eval "$(pyenv init -)"; pyenv versions | grep '* #{python_global_version}']
end
