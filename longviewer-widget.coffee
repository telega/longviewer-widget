# Widget displays data from linode longview on the desktop.
# by telega (tom@telega.org)

# apiKeys should be a comma separated list of longview api keys, from the longview dashboard (https://manager.linode.com/longview)
# for example:
# apiKeys = ["97777777-BBBB-DDDD-34444444444444","F222222222-BBBB-1111-EEEEEEEEEEEE"]

apiKeys = [""]

commandString = "/usr/local/bin/node ./longviewer-widget.widget/lib/longview-data.js "

# this is the shell command that gets executed every time this widget refreshes
command: commandString+apiKeys.join(' ')+" -j"

# the refresh frequency in milliseconds
refreshFrequency: 30000

render: (output) -> """
  <div></div>
"""

update: (output, domEl) ->
  el = $(domEl)
  el.html ''
  data = JSON.parse(output)
  for key in data
    el.append """
      <div class = 'linode'><h2 class='rainbow'>#{key.hostname}</h2><br>
      <span class = 'label'>Distro: </span>#{key.dist} #{key.distversion} <br>
      <span class = 'label'>Available Updates: </span>#{key.packageUpdates} <br>
      <span class = 'label'>Uptime: </span>#{key.uptime}<br>
      <span class = 'label'>CPU: </span>#{key.cpuType}<br>
      <span class = 'label'>CPU Usage: </span>#{key.cpuTotal} <span class = 'label'> Load: </span> #{key.load} <br>
      <span class = 'label'>Memory: </span>#{key.realMemUsed} / #{key.realMem} ( #{key.realMemUsedPercent} )<br>
      <span class = 'label'>Disk: </span>#{key.fsUsed} / #{key.fsFree} (#{key.fsUsedPercent})<br>
      <span class = 'label'>Network In: </span>#{key.rxBytes} <span class = "label">Out: </span>#{key.txBytes} 
    """
    if key.lastUpdated != 0
      el.append """
        <span class = 'warn'>#{key.lastUpdated}</span>
        """
    el.append """
      </div>
    """

# the CSS style for this widget edit the .rainbow class if you want something simpler!
style: """
  top:10px
  left:100px
  font-family:menlo
  color: #fff
  -webkit-font-smoothing: antialiased

  h2
    font-weight: bold
    display: inline-block
    margin-bottom: 4px
    font-size: 22px
  .linode
    margin-top:10px
  .label
    font-weight: bold
  .warn
    color: cyan
  .rainbow
    background-image: -webkit-gradient( linear, left top, right top, color-stop(0, #ff6b6b), color-stop(0.3, #ecf993), color-stop(0.5, #90f98e), color-stop(0.7, #70a8d3),color-stop(1, #bcaee8) )
    color: transparent 
    -webkit-background-clip: text 
"""