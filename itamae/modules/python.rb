python_versions = %w[
  3.5.2
  2.7.12
]

python_global_version = python_versions[0]

package 'pyenv'
package 'pyenv-virtualenv'

[*python_versions, python_global_version].uniq.each do |version|
  execute "pyenv install #{version}" do
    command %[eval "$(pyenv init -)"; PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install #{version}]
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
