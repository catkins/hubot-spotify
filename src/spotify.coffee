# Description:
#   Messing around with the Spotify API. https://developer.spotify.com/web-api/
#
# Commands:
#   hubot spotify (album|track|artist|playlist) <query> - Searches Spotify for the query and returns the embed link
#
# Author:
#   catkins (2015)
#

SPOTIFY_API_SEARCH_ENDPOINT = 'https://api.spotify.com/v1/search'

TYPE_KEYS =
  album:    'albums'
  track:    'tracks'
  artist:   'artists'
  playlist: 'playlists'

module.exports = (robot) ->
  robot.respond /spotify (album|track|artist|playlist) (.*)/i, (msg) ->
    [_, type, query] = msg.match

    robot.http(SPOTIFY_API_SEARCH_ENDPOINT)
      .header('Accept', 'application/json')
      .query(q: query, type: type, limit: 1)
      .get() (err, res, body) ->
        if err
          msg.send err
          return

        data   = JSON.parse body
        result = extractSearchResult data, type

        if result
          msg.send buildResponse(result)
        else
          msg.send "No search results for #{query}"

buildResponse = (result) ->
  response  = result.name
  response += " - #{extractArtists(result)}" if result.artists # for tracks
  response += " - #{extractAlbum(result)}"   if result.album   # for tracks
  response += " - #{extractOwner(result)}"   if result.owner   # for playlists
  response += "\n#{extractUrl(result)}"

extractName = (result) ->
  result.name

extractUrl = (result) ->
  result.external_urls.spotify

extractAlbum = (result) ->
  result.album.name

extractOwner = (result) ->
  result.owner.id

extractArtists = (result) ->
  result.artists.map((artist) -> artist.name).join ', '

# just returns the first result for the time being
extractSearchResult = (data, type) ->
  typeKey = TYPE_KEYS[type]
  items = data[typeKey].items
  items[0]
