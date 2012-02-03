# active_form

This gem is for Rails 3.x.x only! 

## Model

  	class ContactForm < ActiveForm
  	  attr_accessor :name, :institution, :email, :contact_number, :address, :purpose
  	  validates_presence_of :name, :email, :address, :purpose
  	  validates_length_of :email, :within => 6..100, :unless => Proc.new {|m| m.email.blank?}
    end 

## Controller

  	def show
  	  @contact_form = ContactForm.new
  	end
    
  	def send_contact_form
  	  @contact_form = ContactForm.new params[:contact_form]
  		if @contact_form.valid?
  			#...
  		else
  			render :action => "show"
  		end
  	end

## Form

    <%= form_for @contact_form, :url => send_contact_form do |f| %>
      <%= f.error_messages %>
      <%= f.text_field :name %>
      <%= f.text_field :institution %>
      <%= f.text_field :email %>
      <%= f.text_field :contact_number %>
      <%= f.text_field :address %>
      <%= f.select :purpose, ["", "First", "Second"] %>
      <%= f.submit "Request" %>
    <% end %>

## Compatibility

  * MRI Ruby 1.8.7
  * MRI Ruby 1.9.2
  * JRuby 1.6

## How to contribute?

  1. Fork on [GitHub](http://github.com/cs/active_form).
  2. Make sure, that all specs are still passing (run `bundle install && bundle exec rake spec`).
  3. Send Pull Request.

## Copyright

This gem was changed by TnT Web Solutions 2012 to support i18n translation for attributes.

Original:
Copyright ©2011 [Christoph Schiessl](http://github.com/cs). See LICENSE for details.
