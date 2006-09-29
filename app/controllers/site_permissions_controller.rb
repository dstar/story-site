class SitePermissionsController < ApplicationController
  def setup_authorize_hash

    @authorization          = {
      "permissions_destroy" => [ {'permission_type'=>"SitePermission", 'permission'=>"admin"},],
      "permissions"         => [ {'permission_type'=>"SitePermission", 'permission'=>"admin"},],
      "permissions_modify"  => [ {'permission_type'=>"SitePermission", 'permission'=>"admin"},],
    }

  end


  def setup_page_vars
      @page_title = "Modify Site Permissions"
  end

  def permissions_destroy
    case params[:type]
    when /user/
      permission_holder = User.find_by_username(params[:permission_holder])
    when /group/
      permission_holder = Group.find_by_group_name(params[:permission_holder])
    end
    
    permission = SitePermission.find_by_permission_holder_and_permission(permission_holder,params[:permission])
    permission.destroy
    render :action => 'permissions'
  end

  def permissions_modify

    case params[:type]
    when /user/
      permission_holder = User.find_by_username(params[:permission_holder])
    when /group/
      permission_holder = Group.find_by_group_name(params[:permission_holder])
    end
    
    if permission_holder and params[:permission]
      site_permissions=SitePermission.new
      site_permissions.permission_holder = permission_holder
      site_permissions.permission=params[:permission]
      unless site_permissions.save
        flash[:notice] = "Permission Add Failed"
      end
    else
      unless permission_holder
        message = "Unknown User/Group."
      end
      unless params[:permission]
        message += "No Permission Selected."
      end
      flash[:notice]=message
    end
    
    render :action => 'permissions'
  end
end
