class PasswordsController < ApplicationController
  before_action :authenticate_user!,:set_password, only: [:show, :edit, :update, :destroy]

  # Generate the alphabets
  $l_alphabet = ('a'..'z').to_a
  $u_alphabet = ('A'..'Z').to_a
  $digits = ('0'..'9').to_a
  $symbols = (' !"#$%&\'()*+,-./:;<=>?@[\]^_`{|}~').split('')
  # GET /passwords
  # GET /passwords.json
  def index
    @passwords = Password.where(:user_id => current_user.id)
  end

  # GET /passwords/1
  # GET /passwords/1.json
  def show
    current_user_id = current_user.id
    password_user_id = Password.find(params[:id]).user_id
    if current_user_id == password_user_id
      @password = Password.find(params[:id])
    else
      render 'passwords/fail'
    end
  end

  # GET /passwords/new
  def new
    @password = Password.new
  end

  # GET /passwords/1/edit
  def edit
  end

  # POST /passwords
  # POST /passwords.json
  def create
    # if the user has selected to generate a password
    if password_params[:generate] == '1'
      # get the length the user selected default 32
      len = if password_params[:length].blank?
              32
            else
              password_params[:length]
            end
      # check what the user has selected for the inclusion options
      $u_alphabet.clear if password_params[:uppercase] == '1'
      $l_alphabet.clear if password_params[:lowercase] == '1'
      $digits.clear if password_params[:digits] == '1'
      $symbols.clear if password_params[:symbols] == '1'
      e_set = password_params[:exclude]
      # create the new password
      pass = generate_password(len, e_set)
      score, rank = strength_check(pass)

      @password = Password.new(login: password_params[:login], password: pass, site: password_params[:site],
                               user_id: password_params[:user_id], generate: password_params[:generate],
                               uppercase: password_params[:uppercase], lowercase: password_params[:lowercase],
                               symbols: password_params[:symbols], digits: password_params[:digits],
                               length: len, strength: score)
    else
      score, rank = strength_check(password_params[:password])
      @password = Password.new(login: password_params[:login], password: password_params[:password], site: password_params[:site],
                               user_id: password_params[:user_id], generate: password_params[:generate],
                               uppercase: password_params[:uppercase], lowercase: password_params[:lowercase],
                               symbols: password_params[:symbols], digits: password_params[:digits],
                               length: password_params[:password].length, strength: score)
    end


    respond_to do |format|
      if @password.save
        format.html { redirect_to @password, notice: 'Password was successfully created.' }
        format.json { render :show, status: :created, location: @password }
      else
        format.html { render :new }
        format.json { render json: @password.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /passwords/1
  # PATCH/PUT /passwords/1.json
  def update
    respond_to do |format|
      if @password.update(password_params)
        format.html { redirect_to @password, notice: 'Password was successfully updated.' }
        format.json { render :show, status: :ok, location: @password }
      else
        format.html { render :edit }
        format.json { render json: @password.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /passwords/1
  # DELETE /passwords/1.json
  def destroy
    @password.destroy
    respond_to do |format|
      format.html { redirect_to passwords_url, notice: 'Password was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_password
    @password = Password.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def password_params
    params.require(:password).permit(:login, :password, :site, :user_id, :generate, :uppercase, :lowercase,
                                     :symbols, :digits, :strength, :length, :exclude)
  end

  def generate_password(length, e_chars)
    charset = $l_alphabet + $u_alphabet + $digits + $symbols
    charset -= e_chars.split('') unless (e_chars.nil?)
    Array.new(Integer(length)) { charset.sample }.join
  end

  def strength_check(password)
    score = 0
    password_set = password.split('')
    score = if password.size < 12
              -50
            else
              password.size
            end
    score -= 25 if password_set =~ /^[A-Z]+$/i
    score -= 25 if password_set =~ /^\d+$/
    score += 25 if (password_set & $symbols).size > 0
    score += 20 if (password_set & $l_alphabet).size > 0
    score += 20 if (password_set & $u_alphabet).size > 0
    score += 25 if (password_set & $digits).size > 0

    rank = nil
    rank = case
    when score >= 100
      'big brain'
    when score.between?(85, 100)
      'very strong'
    when score.between?(60, 85)
      'strong'
    when score.between?(45, 60)
      'alright'
    when score.between?(0, 45)
      'weak'
    when (password_set.difference($symbols)).size == 0
      'unstable'
    else
      'pathetic'
           end
    return score, rank
  end
end
