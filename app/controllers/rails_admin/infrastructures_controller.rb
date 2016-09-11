class RailsAdmin::InfrastructuresController < RailsAdmin::MainController

  def edit
    @object = @object.becomes Infrastructure
    super
  end

  private

  def handle_save_error whereto = :new
    @object = @object.becomes Infrastructure if whereto == :edit

    # errors are not copied by #becomes
    # see : https://github.com/rails/rails/pull/3438
    #
    # we are in handle_save_error so we know that @object is invalid
    # so just call #valid? once again
    @object.valid?

    super
  end

end
