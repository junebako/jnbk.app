class NikkiController < ApplicationController
  rescue_from Nikki::NotFound, with: :not_found

  def show
    date = params[:date]
    nikki = Nikki.new("juneboku").find_by(date:)

    redirect_to(nikki.url, allow_other_host: true)
  end

  def not_found
    render(plain: "Nikki Not Found!", status: :not_found)
  end
end
