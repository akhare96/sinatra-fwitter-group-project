class TweetsController < ApplicationController

    get '/tweets' do
        @tweets = Tweet.all
        if logged_in?
            erb :'tweets/tweets'
        else
            redirect '/login'
        end
    end
    
    get '/tweets/new' do
        if logged_in?
            erb :'tweets/new'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        if logged_in?
            @tweet = Tweet.create(content: params[:content])
            if !@tweet.save
                redirect '/tweets/new'
            else
                current_user.tweets << @tweet
                current_user.save
                redirect '/tweets'
            end
        else
            redirect '/login'
        end
    end
    
    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :'tweets/show_tweet'
        else
            redirect '/login'
        end
    end

    get '/tweets/:id/edit' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet.user == current_user
                erb :'tweets/edit_tweet'
            else
                redirect "/tweets"
            end
        else
            redirect '/login'
        end
    end

    patch '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet.user == current_user
                @tweet.update(content: params[:content])
                if @tweet.save
                    redirect "/tweets/#{@tweet.id}"
                else
                    redirect "/tweets/#{@tweet.id}/edit"
                end
            else
                redirect '/tweets'
            end
        else
            redirect 'login'
        end
    end

    delete '/tweets/:id/delete' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet.user == current_user
                @tweet.delete
                redirect '/tweets'
            else
                redirect "/tweets/#{@tweet.id}"
            end
        else
            redirect '/login'
        end
    end

end
