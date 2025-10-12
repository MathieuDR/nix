{pkgs, ...}: {
  #https://wiki.nixos.org/wiki/AMD_GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Might be detrimental to performance
  ## Boot
  # boot.initrd.kernelModules = ["amdgpu"]; # Load amdgpu driver before boot

  ## Enable AMD overclocking
  # boot.kernelModules = ["amdgpu"];

  systemd.packages = with pkgs; [
    ## Monitors ##
    lact
    amdgpu_top # Tool for AMDGPU Usage

    ## Tools ##
    glxinfo # OpenGL info
    #vulkan-tools # Khronos official Vulkan Tools and Utilities
    #clinfo # Print information about available OpenCL platforms and devices
    #libva-utils # Collection of utilities and examples for VA-API
  ];

  #LACT, to overclock, undervolt and set fan curves
  environment.systemPackages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # Force RADV, might not be needed as we don't have AMDVLK
  # If we want AMDVLK, check this: https://wiki.nixos.org/wiki/AMD_GPU#AMDVLK
  # environment.variables.AMD_VULKAN_ICD = "RADV";
}
