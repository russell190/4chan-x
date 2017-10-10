#This script finds all instances of a youtube link within a given document and imputes it with proper hooktube syntax. This is a followup to issue {insert issue here} off of the 4chan x master branch. Patch made by https://www.github.com/russell190

$(document).ready ->

links = document.evaluate("//a[@href]",
    document,
    null,
    XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE,
    null);

for (var i=0;i<links.snapshotLength;i++) {
    var thisLink = links.snapshotItem(i);

  thisLink.href = thisLink.href.replace(RegExp('https?://www\\.youtube\\.com/(.*)'),
                                      'https://www\.hooktube\.com/$1');

  thisLink.href = thisLink.href.replace(RegExp('https?://youtu\\.be/(.*)'),
                                      'https://www\.hooktube\.com/watch\?v=$1');
}


key: 'YouTube'
      regExp: /^\w+:\/\/(?:hooktube\/|[\w.]*hooktube[\w.]*\/.*(?:v=|\bembed\/|\bv\/))([\w\-]{11})(.*)/
      el: (a) ->
        start = a.dataset.options.match /\b(?:star)?t\=(\w+)/
        start = start[1] if start
        if start and !/^\d+$/.test start
          start += ' 0h0m0s'
          start = 3600 * start.match(/(\d+)h/)[1] + 60 * start.match(/(\d+)m/)[1] + 1 * start.match(/(\d+)s/)[1]
        el = $.el 'iframe',
          src: "//redirector.googlevideo.com/videoplayback?key=yt6&id=#{a.dataset.uid}&ip="& regExp: \d{3}\.\d{3}\.\d{3}\.\d{3} & "&itag='"& regExp = \d{2} &"'" & "&ms=au&signature=#{a.dataset.uid}&pl=28&mime=video/mp4&mn="& regExp = \w{2}\-\w{8} & "&mt=" & regExp = \d{10}"&ipbits=0&mm=31&sparams=dur,ei,id,ip,ipbits,itag,lmt,mime,mm,mn,ms,mv,pl,ratebypass,source,expire&utmg=ytap1,,medium?rel=0&wmode=opaque#"
        el.setAttribute "allowfullscreen", "true"
        el
      title:
        batchSize: 50
        api: (uids) ->
          ids = encodeURIComponent uids.join(',')
          key = '<%= meta.youtubeAPIKey %>'
          "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=#{ids}&fields=items%28id%2Csnippet%28title%29%29&key=#{key}"
        text: (data, uid) ->
          for item in data.items when item.id is uid
            return item.snippet.title
          'Not Found'
      preview:
        url: (uid) -> "https://img.hooktube.com/vi/#{uid}/0.jpg"
height: 360