module Tolk
  class LocalesController < Tolk::ApplicationController
    before_filter :find_locale, :only => [:show, :all, :update, :updated]
    before_filter :ensure_no_primary_locale, :only => [:all, :update, :show, :updated]

    def index
      @locales = Tolk::Locale.secondary_locales
    end
  
    def show
      respond_to do |format|
        format.html do
          temp = paginate_phrases(@locale.phrases_without_translation, params[:page])
          @phrases = temp[:results]
          @phrase_pages = temp[:result_pages]
          redirect_to url_for(params.merge(:page => nil)) if @phrases.size < 1 unless params[:page].to_i == 1
        end
        format.atom { @phrases = @locale.phrases_without_translation(params[:page], :per_page => 50) }
        format.yaml { render :text => @locale.to_hash.ya2yaml(:syck_compatible => true) }
      end
    end

    def update
      @locale.translations_attributes = params[:translations]
      @locale.save
      redirect_to request.referrer
    end

    def all
      temp = paginate_phrases(@locale.phrases_with_translation, params[:page])
      @phrases = temp[:results]
      @phrase_pages = temp[:result_pages]
      redirect_to url_for(params.merge(:page => nil)) if @phrases.size < 1 unless params[:page].to_i == 1
    end

    def updated
      @phrases = @locale.phrases_with_updated_translation(params[:page])
      render :all
    end

    def create
      Tolk::Locale.create!(params[:tolk_locale])
      redirect_to :action => :index
    end

    private

    def find_locale
      @locale = Tolk::Locale.find_by_name!(params[:id])
    end
        
    def paginate_phrases(scoped_phrases, current_page, options={})
      total = scoped_phrases.size
      phrases = scoped_phrases.page(current_page).all
      translations_for_phrases = Tolk::Translation.where({:locale_id => @locale.id, :phrase_id => phrases.collect(&:id)}).all
      phrases.each { |phrase| phrase.translation = translations_for_phrases.detect { |t| t.phrase_id == phrase.id } }
      result_pages = ::ActionController::Pagination::Paginator.new(self, total, Tolk::Phrase.per_page, current_page)
      
      Tolk::Phrase.send :preload_associations, phrases, :translations
      {
        :results => phrases,
        :result_pages => result_pages
      }
    end
  end
end
