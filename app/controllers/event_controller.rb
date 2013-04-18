class EventController < ApplicationController
  require 'date'
  require 'koala'
  require 'twitter'
  require 'nokogiri'
  require 'uri'
  require 'open-uri'
  require 'pp'

  # イベント一覧を表示します.
  def index
    #@graph = Koala::Facebook::API.new 'AAACEdEose0cBAEU6hHXfIZCBZC0v5pWFZCMZAItFsAMqIzemu8AkNpeTR7MA0v97KMCbLzZA7eKdY6ZAz2wJG3ZAxSy8b8HtVEJLZC0SFQKdsQzl1M7QXbQu'

    @favorite_users = FavoriteUser.all

    #today = Date.today
    #first_day = Date.new today.year, today.month, 1
    #last_day = Date.new today.year, today.month, -1
    #
    #@events = Hash.new { |hash,key| hash[key] = Hash.new {} }
    #@favorite_users.each do |user|
    #  attending_event = @graph.get_connections user[:fb_id], 'events', 'type' => 'attending', 'since' => first_day.to_time.to_i, 'until' => last_day.to_time.to_i
    #  tmp = Hash.new
    #  tmp.store 'attending', attending_event
    #
    #  not_replied_event = @graph.get_connections user[:fb_id], 'events', 'type' => 'not_replied', 'since' => first_day.to_time.to_i, 'until' => last_day.to_time.to_i
    #  tmp2 = Hash.new
    #  tmp2.store 'not_replied', not_replied_event
    #
    #  tmp.merge! tmp2
    #
    #  @events.store user[:fb_id], tmp
    #end

    if params[:year] && params[:month]
      date = Date.new params[:year], params[:month], Date.today.day
    else
      date = Date.today
    end

    @weeks = []
    week = Array.new(7)

    @year = date.year
    @month = date.month
    lastDay = Date.new(@year, @month, -1).day

    (1..lastDay).each {|day|
      time = Time.local(@year, @month, day)
      week[time.wday] = day

      if time.wday == 6 || day == lastDay
        @weeks.push(week)
        week = Array.new(7)
      end
    }
    render 'event/index'
  end

  def twitter
    user = User.find current_user.id
    client = Twitter::Client.new :oauth_token => user.token, :oauth_token_secret => user.token_secret, :consumer_key => 'rWEIzBKEIxH9AVMTRLbQ', :consumer_secret => 'mOtaxTsve6398WjMwY3nplyXTaHMOeuATxGvio2aKUY'
    tweets = client.user_timeline 'Shimpe1', :include_entities => true

    #full_text = tweets[0].full_text
    #pp tweets[0]
    #pp tweets[0].urls
    #urls =  URI.extract(full_text, %w[http])
    #doc = Nokogiri::HTML(open('http://kokucheese.com/event/index/81809/'))
    #elm = doc.xpath '//*[@id="left"]/div[2]/table/tr[1]/td'
    #pp elm
    tweets.each do |tweet|
      if /http/ =~ tweet.full_text
        pp tweet.urls
        #urls =  URI.extract(tweet.full_text, %w[http])
        #doc = Nokogiri::HTML(open(urls[0]))
      end
    end
  end

  def list
    user = User.find current_user.id
    @graph = Koala::Facebook::API.new user.token
    #@graph = Koala::Facebook::API.new 'AAACEdEose0cBAOshEWRgVEkLbZBukK5R9IVtBTIZADzRTl2cDpldNGxJybo62xQM3oFdQNwEKo4HfAUZAB8R9DZATRA5E9pyR2lhiQrmKIoQTXd5VWj2'

    today = Date.today
    first_day = Date.new today.year, today.month, 1
    last_day = Date.new today.year, today.month, -1

    @events = Hash.new { |hash,key| hash[key] = Hash.new {} }

    fb_user = FavoriteUser.find_by_fb_id params[:id]

    attending_event = @graph.get_connections fb_user[:fb_id], 'events', 'type' => 'attending', 'since' => first_day.to_time.to_i, 'until' => last_day.to_time.to_i
    tmp = Hash.new
    tmp.store 'attending', attending_event

    maybe_event = @graph.get_connections fb_user[:fb_id], 'events', 'type' => 'maybe', 'since' => first_day.to_time.to_i, 'until' => last_day.to_time.to_i
    tmp2 = Hash.new
    tmp2.store 'maybe', maybe_event

    not_replied_event = @graph.get_connections fb_user[:fb_id], 'events', 'type' => 'not_replied', 'since' => first_day.to_time.to_i, 'until' => last_day.to_time.to_i
    tmp3 = Hash.new
    tmp3.store 'not_replied', not_replied_event

    tmp.merge! tmp2
    tmp.merge! tmp3

    @events.store fb_user[:fb_id], tmp

    respond_to do |format|
      format.html { render layout: (request.headers["X-Requested-With"] != 'XMLHttpRequest') }
      format.json { render json: make_date_hash(@events) }
    end
  end

  def make_date_hash(events)
    result = Hash.new
    events.each do |fb_id, events_by_type|
      events_by_type.each do |type, events_array|
        events_array.each do |event|
          # TODO %dでフォーマットして先頭の「0」を削除するようにする
          date = custom_parse(event['start_time']).strftime('%e').lstrip
          unless result.key? date
            #result.store date, Hash.new
            result.store date, Array.new
          end
          #if result[date].key? fb_id
          #  result[date][fb_id].push event
          #elsif
          #  result[date].store fb_id, Array.new(1, event)
          #end
          #event['fb_id'] = Array.new(1, fb_id)
          #if result[date].key? event['id']
          #  result[date][event['id']]['fb_id'].push fb_id
          #elsif
          #  result[date].store event['id'], event
          #end
          event['fb_id'] = Array.new(1, fb_id)
          if result[date].include? event
            index = result[date].index(event)
            result[date][index]['fb_id'].push fb_id
          elsif
          result[date].push event
          end
        end
      end
    end
    result
  end

  private
  # 文字列を日付に変換
  def custom_parse(str)
    date = nil
    if str && !str.empty? #railsなら、if str.present? を使う
      begin
        date = DateTime.parse(str)
          # parseで処理しきれない場合
      rescue ArgumentError
        formats = ['%Y:%m:%d %H:%M:%S'] # 他の形式が必要になったら、この配列に追加
        formats.each do |format|
          begin
            date = DateTime.strptime(str, format)
            break
          rescue ArgumentError
          end
        end
      end
    end
    return date
  end
end
