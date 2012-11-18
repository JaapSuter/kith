#ifndef WINAROUND_H_INCLUDED
#define WINAROUND_H_INCLUDED

#if defined WIN32 || defined WIN64
    #define strcasecmp _stricmp
    #define strncasecmp _strnicmp
    #define WINAROUND_REMOVE_ON_WIN(x)


    char* strndup (const char *s, size_t n)
    {
      char *result;
      size_t len = strlen (s);

      if (n < len)
        len = n;

      result = (char *) malloc (len + 1);
      if (!result)
        return 0;

      result[len] = '\0';
      return (char *) memcpy (result, s, len);
    }
#else
    #define WINAROUND_REMOVE_ON_WIN(x) x
#endif

#endif
