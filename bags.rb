#!/usr/bin/env ruby

require "net/http"
require "uri"
require "nokogiri"
require "sinatra"
#set :bind, '0.0.0.0'

$html = File.open("res.html").read

code = <<EOF
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>エロゲ福袋</title>
    <meta charset="utf-8">
    <meta name="description" content="2010年代に発売されたエロゲを3本選んで返してくれる奴">
    <meta name-"author" content="@owatan@mstdn.maud.io">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
  </head>
  <body class="container">
    <h1>エロゲ福袋</h1>
    <p>
      <a href="https://erogamescape.dyndns.org/~ap2/ero/toukei_kaiseki/">エロゲー批評空間</a> の情報をもとに
      下記条件に合致したエロゲを 3本返してくれます。
      スクレイピング元は<a href="https://erogamescape.dyndns.org/~ap2/ero/toukei_kaiseki/usersql_exec.php?sql_id=2121">ここ</a>
    </p>

    <ul>
      <li><code>2010/01/01</code>から<code>2018/12/31</code>までに発売された作品</li>
      <li>中央値が<code>75</code>以上、かつプレイ数が<code>10</code>以上</li>
      <li>同人ゲーム<span class="font-weight-bold">ではない</span></li>
      <li>PC ゲーム</li>
    </ul>

    <table class="table">
      <thead>
        <tr>
          <th scope="col">発売日</th>
          <th scope="col">ブランド</th>
          <th scope="col">タイトル</th>
          <th scope="col">中央値</th>
          <th scope="col">プレイ数</th>
        </tr>
      </thead>
      <tbody>
        <% res = Nokogiri::HTML.parse($html, nil, "utf-8") %>
        <% res.xpath('//table/tr').to_a.drop(1).sample(3).each do |obj| %>
        <tr>
          <td><%= obj.xpath('td')[0].text() %></td>
          <td><%= obj.xpath('td')[1].text() %></td>
          <td>
            <a href="<%= obj.xpath('td')[3].text() %>">
              <%= obj.xpath('td')[2].text() %>
            </a>
          </td>
          <td><%= obj.xpath('td')[4].text() %></td>
          <td><%= obj.xpath('td')[5].text() %></td>
        </tr>
        <% end %>
      </tbody>
    </table>
    <hr />
    <p class="text-right"><a href="https://mstdn.maud.io/@owatan">@owatan@mstdn.maud.io</a></p>
  </body>
</html>
EOF

get "/" do
  erb code
end

