using System.Runtime.InteropServices;
using TsudaKageyu;


namespace LaunchpadDotNet
{

    public class LaunchpadFiles
    {
        [UnmanagedCallersOnly(EntryPoint = "extract_icon")]
        public static int ExtractIcon(IntPtr inputPathPtr, IntPtr outputPathPtr, bool overwrite = false)
        {
            string? inputPath = Marshal.PtrToStringAnsi(inputPathPtr);
            string? outputPath = Marshal.PtrToStringAnsi(outputPathPtr);

            if (inputPath == null || outputPath == null)
            {
                return -1;
            }

            try
            {
                if (!File.Exists(inputPath))
                {
                    return -1;
                }

                if (File.Exists(outputPath))
                {
                    if (!overwrite)
                    {
                        return -1;
                    }

                    File.Delete(outputPath);
                }

                IconExtractor extractor = new IconExtractor(inputPath);

                if (extractor.Count == 0) {
                    return -1;
                }

                using (var fs = File.OpenWrite(outputPath))
                {
                    extractor.Save(0, fs);
                }
            }
            catch
            {
                return -1;
            }

            return 1;
        }
    }
}
