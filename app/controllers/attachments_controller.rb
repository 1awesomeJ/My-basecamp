class AttachmentsController < ApplicationControllerp
  def purge
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_back fallback_location: projects_path, notice: "file removed successfully"
  end
end
