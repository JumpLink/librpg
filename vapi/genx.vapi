[CCode (cheader_filename = "genx-glib.h")]
namespace Genx {

    [CCode (cname = "genxStatus", cprefix = "GENX_")]
    public enum Status {
        SUCCESS,
        BAD_UTF8,
        NON_XML_CHARACTER,
        BAD_NAME,
        ALLOC_FAILED,
        BAD_NAMESPACE_NAME,
        INTERNAL_ERROR,
        DUPLICATE_PREFIX,
        SEQUENCE_ERROR,
        NO_START_TAG,
        IO_ERROR,
        MISSING_VALUE,
        MALFORMED_COMMENT,
        XML_PI_TARGET,
        MALFORMED_PI,
        DUPLICATE_ATTRIBUTE,
        ATTRIBUTE_IN_DEFAULT_NAMESPACE,
        DUPLICATE_NAMESPACE,
        BAD_DEFAULT_DECLARATION
    }
    
    [Compact]
    [CCode (cname = "struct genxWriter_rec", free_function = "genxDispose")]
    public class Writer {
    
        [CCode (has_target = 0)]
        public delegate void* AllocCallback(void* user_data, int bytes);
        [CCode (has_target = 0)]
        public delegate void DeallocCallback(void* user_data, void* data);
        
        private static void* default_alloc(void* user_data, int bytes) {
            return GLib.malloc(bytes);
        }
        private static void default_dealloc(void* user_data, void* data) {
            GLib.free(data);
        }
        
        [CCode (cname = "genxNew")]
        public Writer(
                AllocCallback alloc = default_alloc,
                DeallocCallback dealloc = default_dealloc,
                void* user_data = null);
        
        public unowned Namespace declare_namespace(string uri, string prefix);
        
        public unowned Element declare_element(Namespace ns, string type);
        
        public unowned Attribute declare_attribute(Namespace ns, string name);
        
        [CCode (cname = "genx_writer_start_doc_gstring")]
        public void start_doc(GLib.StringBuilder output);
        
        public void end_document();
        
        public void comment(string text);
        
        public void pi(string target, string text);
        
        public void start_element_literal(string xmlns, string type);
        
        public void add_attribute_literal(string xmlns, string name, string value);
        
        public void unset_default_namespace();
        
        public void end_element();
        
        public void add_text(string text);
        
        public void add_character(int character);
    
    }
    
    [Compact]
    [CCode (cname = "struct genxNamespace_rec", free_function = "NAMESPACE_HAS_NO_PUBLIC_FREE")]
    public class Namespace {
    
        public void add(string? prefix = null);
    
    }
    
    [Compact]
    [CCode (cname = "struct genxElement_rec", free_function = "ELEMENT_HAS_NO_PUBLIC_FREE")]
    public class Element {
    
        public void start();
    
    }
        
    [Compact]
    [CCode (cname = "struct genxAttribute_rec", free_function = "ATTRIBUTE_HAS_NO_PUBLIC_FREE")]
    public class Attribute {
    
        public void add(string value);
    
    }

}
