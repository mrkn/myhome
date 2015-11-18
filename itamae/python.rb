python_versions = %w[
  2.7.10
  3.5.0
]

python_global_version = '3.5.0'

package 'pyenv'
package 'homebrew/boneyard/pyenv-pip-rehash'

[*python_versions, python_global_version].uniq.each do |version|
  execute "pyenv install #{version}" do
    command %[eval "$(pyenv init -)"; pyenv install #{version} && PYENV_VERSION=#{version} pip install --upgrade pip]
    not_if  %[eval "$(pyenv init -)"; pyenv versions | grep #{version}]
  end
end

execute "pyenv global #{python_global_version}" do
  command %[eval "$(pyenv init -)"; pyenv global #{python_global_version}]
  not_if  %[eval "$(pyenv init -)"; pyenv versions | grep '* #{python_global_version}']
end
