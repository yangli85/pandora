require 'fileutils'
require 'fastimage'

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

      def get_image_size image_path
        sizes = FastImage.size(image_path)
        {width: sizes[0], height: sizes[1]} if sizes.length==2
      end
    end
  end
end