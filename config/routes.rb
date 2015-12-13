Rails.application.routes.draw do

  root 'welcome#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/devel/emails'
  end

  devise_for :users,
             controllers: { sessions: 'sessions' },
             path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  resources :users, only: [] do
    resources :calendars do
      EventableRouter.new(self).render
    end
  end

  ## User edit profile
  scope 'my' do
    match 'account', to: 'my#account', as: 'my_account', via: [:get, :patch]
  end

  ## Admin section
  namespace :admin do
    root to: 'welcome#index'

    resources :settings, only: [:index]

    resources :users do
      member do
        # Administrators can change password for users
        match 'change_password', as: 'change_password', via: [:get, :patch]
      end
    end
  end

  match '/caldav/calendars/:owner', owner: CalDav::OWNER_REGEX,
                                    via: [:all],
                                    as: :principal,
                                    to: DAV4Rack::Handler.new(
                                      root:             '/caldav/calendars',
                                      root_uri_path:    '/caldav/calendars',
                                      resource_class:   CalDav::Resources::Principal,
                                      controller_class: CalDav::Controllers::Principal
                                    )

  match '/caldav/calendars/:owner/:calendar', owner: CalDav::OWNER_REGEX,
                                              calendar: CalDav::CALENDAR_REGEX,
                                              via: [:all],
                                              as: :ics_calendar,
                                              to: DAV4Rack::Handler.new(
                                                root:             '/caldav/calendars',
                                                root_uri_path:    '/caldav/calendars',
                                                resource_class:   CalDav::Resources::Calendar,
                                                controller_class: CalDav::Controllers::Calendar,
                                              )

  match '/caldav/calendars/:owner/:calendar/:event',  owner: CalDav::OWNER_REGEX,
                                                        calendar: CalDav::CALENDAR_REGEX,
                                                        event: CalDav::EVENT_REGEX,
                                                        via: [:all],
                                                        as: :ics_event,
                                                        to: DAV4Rack::Handler.new(
                                                          root:             '/caldav/calendars',
                                                          root_uri_path:    '/caldav/calendars',
                                                          resource_class:   CalDav::Resources::Event,
                                                          controller_class: CalDav::Controllers::Event
                                                        )

end
