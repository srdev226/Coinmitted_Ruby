module ProfilesHelper

  def profile_avatar(profile, size, avatar_class='user-img')
    if profile.avatar.attached?
      image_tag profile.avatar.variant(combine_options: image_options(size)), alt: profile.name, class: avatar_class
    else
      image_tag "default-user.png", alt: profile.name, class: avatar_class
    end
  end

end
