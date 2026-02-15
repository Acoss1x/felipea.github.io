import React from "react";

type Props = {
  videoUrl?: string; 
  photoUrl?: string; 
};

const SkillsList: React.FC<Props> = ({
  videoUrl,
  photoUrl,
}) => {
  return (
    <div className="text-left pt-3 md:pt-9">
      <h3 className="text-[var(--white)] text-3xl md:text-4xl font-semibold md:mb-6">
        Presentación
      </h3>

      <div className="mt-6 grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* VIDEO */}
        <div className="w-full bg-[#1414149c] rounded-2xl border border-[var(--white-icon-tr)] overflow-hidden">
          <div className="p-4">
            <p className="text-[var(--white-icon)] text-sm mb-3">Video</p>

            {videoUrl ? (
  <div className="w-full flex justify-center">
    <div className="relative w-full max-w-[340px] aspect-[9/16] rounded-xl overflow-hidden">
      <iframe
        className="absolute inset-0 w-full h-full"
        src={videoUrl}
        title="Video de presentación"
        frameBorder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowFullScreen
      />
    </div>
  </div>
) : (
  <div className="w-full aspect-[9/16] max-w-[340px] mx-auto rounded-xl border border-dashed border-[var(--white-icon-tr)] flex items-center justify-center">
    <span className="text-[var(--white-icon)] text-sm opacity-80">
      Aquí va tu video (embed)
    </span>
  </div>
)}
          </div>
        </div>

        {/* FOTO */}
        <div className="w-full bg-[#1414149c] rounded-2xl border border-[var(--white-icon-tr)] overflow-hidden">
          <div className="p-4">
            <p className="text-[var(--white-icon)] text-sm mb-3">Foto</p>

            {photoUrl ? (
              <div className="w-full rounded-xl overflow-hidden">
                <img
                  src={photoUrl}
                  alt="Foto de presentación"
                  className="w-full h-auto object-cover"
                />
              </div>
            ) : (
              <div className="w-full aspect-square rounded-xl border border-dashed border-[var(--white-icon-tr)] flex items-center justify-center">
                <span className="text-[var(--white-icon)] text-sm opacity-80">
                  Aquí va tu foto
                </span>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default SkillsList;
