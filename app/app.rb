module AtpStatistics
  # Main
  class App < Padrino::Application
    use ConnectionPoolManagement
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    get "/" do
      "Hello World!"
    end
  end
end
