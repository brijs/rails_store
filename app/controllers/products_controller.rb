class ProductsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :edit, :new, :create, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.search(params[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @products }
    end
  end


  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        flash[:success] = 'Product was successfully created.'
        format.html { redirect_to @product }
        format.json { render :json => @product, :status => :created, :location => @product }
      else
        flash[:error] = 'Error creating a new product'
        format.html { render :action => "new" }
        format.json { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        flash[:success] = 'Product was successfully updated.'
        format.html { redirect_to @product}
        format.json { head :no_content }
      else
        flash.now[:error] = 'Error updating a new product'
        format.html { render :action => "edit" }
        format.json { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  

  private
  
  def signed_in_user
    redirect_to signin_path, notice: "Please sign in." unless signed_in?
  end

end
