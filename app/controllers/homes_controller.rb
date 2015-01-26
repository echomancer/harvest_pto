class HomesController < ApplicationController
  before_action :set_home, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @homes = Home.all
    if @home.nil?
      Home.create(name: "Shazzam")
    end
    @homes = Home.all
    respond_with(@homes)
  end

  def show
    respond_with(@home)
  end

  def new
    @home = Home.new
    respond_with(@home)
  end

  def edit
  end

  def create
    @home = Home.new(home_params)
    @home.save
    respond_with(@home)
  end

  def update
    @total = 0
    @used = 0
    @left = 0
    if params[:home].present?   # Is the login set
      subdomain = home_params[:subdomain]
      username = home_params[:username]
      password = home_params[:password]

      harvest = Harvest.hardy_client(subdomain: subdomain, username: username, password: password)

      puts "Projects:"
      harvest.time.trackable_projects.each do |project|
        puts project 
        time = Time.new
        starty = Time.parse("01/01/#{time.year}")
        endy = Time.parse("31/12/#{time.year}")
        entries = harvest.reports.time_by_project(project.id, starty, endy) # Apparently can't be called by normal user
        puts "Entries:"
        entries.each {|e| p e}
      end
    end
    #@home.update(home_params)
    respond_with(@home)
  end

  def destroy
    @home.destroy
    respond_with(@home)
  end

  private
    def set_home
      @home = Home.find(params[:id])
    end

    def home_params
      params.require(:home).permit(:name,:subdomain,:username,:password)
    end
end
