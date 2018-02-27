#!/bin/bash
#
# NodeQuery Agent Installation Script
#
# @version		1.0.6
# @date			2014-07-30
# @copyright	(c) 2014 http://nodequery.com
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Set environment
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Prepare output
echo -e "|\n|   NodeQuery Installer\n|   ===================\n|"

# Parameters required
if [ $# -lt 1 ]
then
	echo -e "|   Usage: bash $0 'token'\n|"
	exit 1
fi


	# Remove cron entry and user
	if id -u $USER >/dev/null 2>&1
	then
		(crontab -u $USER -l | grep -v "$HOME/nodequery/nq-agent.sh") | crontab -u $USER
	else
		(crontab -u $USER -l | grep -v "$HOME/nodequery/nq-agent.sh") | crontab -u $USER
	fi
fi

# Create agent dir
mkdir -p /etc/nodequery

# Download agent
echo -e "|   Downloading nq-agent.sh to $HOME/nodequery\n|\n|   + $(wget -nv -o /dev/stdout -O $HOME/nodequery/nq-agent.sh --no-check-certificate https://raw.github.com/Dedsec1/nq-agent/master/nq-agent.sh)"

if [ -f $HOME/nodequery/nq-agent.sh ]
then
	# Create auth file
	echo "$1" > $HOME/nodequery/nq-auth.log
	
	# Create user
	useradd nodequery -r -d $HOME/nodequery -s /bin/false
	
	# Modify user permissions
	
	
	# Modify ping permissions
	chmod +s `type -p ping`

	# Configure cron
	crontab -u $USER -l 2>/dev/null | { cat; echo "*/3 * * * * bash $HOME/nodequery/nq-agent.sh > $HOME/nodequery/nq-cron.log 2>&1"; } | crontab -u $USER
	
	# Show success
	echo -e "|\n|   Success: The NodeQuery agent has been installed\n|"
	
	# Attempt to delete installation script
	if [ -f $0 ]
	then
		rm -f $0
	fi
else
	# Show error
	echo -e "|\n|   Error: The NodeQuery agent could not be installed\n|"
fi
