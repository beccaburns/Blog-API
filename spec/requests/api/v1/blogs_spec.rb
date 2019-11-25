require 'rails_helper'

RSpec.describe 'Api::V1::Blogs', type: :request do
  path '/v1/blogs' do
    post 'Creates a blog' do
      tags 'Blogs'
      description 'Creates an instance of a Blog.'
      consumes 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'Trip to France' },
          content: { type: :string, example: 'Cheese, Bread & Wine!'},
          author: { type: :string, example: 'Becca' },
          image: { type: :string, 'x-nullable': true, example: 'Base64 encoded image' }
        },
        required: %w[title content author]
      }

      response '201', 'blog created' do
        let(:blog) do
          { title: 'Trip to France',
            content: 'We stayed the night in a castle.',
            author: 'Becca' }
        end
        run_test! do
          expect(response_json['message'].to eq 'The recipe was successfully created.')
        end
      end

      response '422', 'invalid request' do
        let(:blog) do
          { title: '',
            content: '',
            author: '' }
        end
        run_test! do
          expect(response_json['error_message']).to eq 'Unable to create blog.'
        end
      end
    end

    get 'Returns a collection of blogs' do 
      tags 'Blogs'
      description 'Returns collection of blogs in the system.'
      consumes 'application/json'
      produces 'application/json'
      response '200', 'Collection of blogs returned' do
        schema properties: {
          blogs: {
            type: :array,
            items: {
              properties: {
                id: { type: :integer },
                title: { type: :string },
                content: { type: :string },
                author: { type: :string }
              }
            }
          }
        }
        before { create_list(:blog, 6) }
        run_test! do
          expect(response_json['blogs'].count).to eq 6
        end
      end
    end
  end
  path 'api/v1/blogs/{id}' do
    get 'Returns a blog' do
      tags 'Blogs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, required: true
      response '200', 'Blog found' do
        schema properties: {
          blog: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              content: { type: :string },
              author: { type: :string }
            }
          }
        }
        let(:id) { create(:blog).id }
        run_test!
      end
    end
  end
end