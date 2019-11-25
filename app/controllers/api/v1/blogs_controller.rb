class Api::V1::BlogsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    blogs = Blog.all
    render json: blogs, each_serializer: Blogs::IndexSerializer
  end

  def create
    blog = Blog.create(blog_params)
    if blog.persisted?
      attach_image(blog)
      render json: { message: 'The blog was successfully created.' }, status: 201
    else
      render json: { error_message: 'Unable to create blog.' }, status: 422
    end
  end
end