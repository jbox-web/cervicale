class EventableRouter < SimpleDelegator

  def initialize(router)
    super(router)
  end

  def render
    resources :event_collections, controller: 'events'
    resources :events do
      member do
        post 'move'
        post 'resize'
      end
    end
  end

end
