dep 'nodejs.src' do
  source 'http://nodejs.org/dist/node-v0.4.11.tar.gz'
  provides 'node'
end

dep 'JavaScript Node.tmbundle' do
  source 'git://github.com/drnic/javascript-node.tmbundle.git'
end

dep 'JavaScript Tools.tmbundle' do
  source 'git://github.com/subtleGradient/javascript-tools.tmbundle.git'
end

dep 'Node Development Environment' do
  requires 'nodejs.src', 'JavaScript Node.tmbundle', 'JavaScript Tools.tmbundle'
end
