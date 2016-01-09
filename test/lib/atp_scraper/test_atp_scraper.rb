require "test/unit"

class TestAtpScraper < Test::Unit::TestCase
  # サンプルは2012年のNadalのActivity
  # http://www.atpworldtour.com/players/rafael-nadal/n409/player-activity?year=2012
  @@html = File.open('test/lib/atp_scraper/sample.html').read
  @@html_charset = "utf-8"

  def setup
    @@atp_scraper = AtpScraper::Activity.new
    @@activity_doc = AtpScraper::Get.parse_html(@@html, @@html_charset)
    
    # 2012年のWimbledonのデータ
    @@tournament_doc = @@atp_scraper.search_tournaments_doc(@@activity_doc).first
    @@tournament_info = @@atp_scraper.pickup_tournament_info(@@tournament_doc)

    # 2012年のWimbledonの対Rosolのデータ
    @@record_doc = @@atp_scraper.search_records_doc(@@tournament_doc).first
  end

  def test_pickup_player_name
    expect = 'Rafael Nadal'
    assert_equal(
      @@atp_scraper.pickup_player_name(@@activity_doc),
      expect
    )
  end

  def test_pickup_tournament_info
    expect = {
      name: 'Wimbledon',
      location: 'London, Great Britain',
      date: { start: '2012.06.25', end: '2012.07.08' },
      year: '2012',
      caption: 'This Event Points: 45, ATP Ranking: 2, Prize Money: £23,125',
      surface: 'OutdoorGrass'
    }
    assert_equal(
      @@atp_scraper.pickup_tournament_info(@@tournament_doc),
      expect
    )
  end

  def test_pickup_pleyer_rank
    expect = '2'
    assert_equal(
      @@atp_scraper.pickup_player_rank(@@tournament_info[:caption]),
      expect
    )
  end

  def test_pickup_record
    expect = {
      round: 'Round of 64',
      opponent_rank: '100',
      opponent_name: 'Lukas Rosol',
      win_loss: 'L',
      score: '769 46 46 62 46'
    }
    assert_equal(
      @@atp_scraper.pickup_record(@@record_doc),
      expect
    )
  end

  def test_pickup_surface
    expect = 'OutdoorGrass'
    assert_equal(
      @@atp_scraper.pickup_surface(@@tournament_doc),
      expect
    )
  end

  def test_divide_tournament_date
    actual = '2011.01.03 - 2011.01.08'
    expect = { start: '2011.01.03', end: '2011.01.08' }
    assert_equal(
      @@atp_scraper.divide_tournament_date(actual),
      expect
    )
  end
end
