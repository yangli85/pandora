require 'fileutils'

module Pandora
  module Common
    module ServiceHelper
      def move_image_to old_image_path, new_folder
        new_image_path = "#{new_folder}/#{base_name(old_image_path)}"
        FileUtils.mv old_image_path, new_image_path
        new_image_path
      end

      def base_name image_path
        File.basename image_path
      end

      def anonymous_phone phone
        phone[3..6]="****"
        phone
      end
    end
  end
end