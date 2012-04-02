module SessionsHelper
	# all methods defined below (** helper methods**) are automatically accessible
	# from various views by default, and by various controllers (after include 
	# statements).

	def sign_in (user)
		cookies.permanent[:remember_token] = user.remember_token
		current_user = user
		# note: above calls the assignment method(helper function below)
	end
	
	def current_user=(user)
		current_user = user
	end

	def current_user
		current_user ||= user_from_remember_token
	end

  	def current_user?(user)
    	user == current_user
	end	
	
	def user_from_remember_token
		# token below is supplied by the browser
		remember_token = cookies[:remember_token]
		User.find_by_remember_token(remember_token) unless remember_token.nil?
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		current_user = nil
		cookies.delete(:remember_token)
	end

end
