using System.Collections.Generic;
using System.Diagnostics;
using UnityEditor;
using UnityEngine;

public class AnimationReferenceFixer : EditorWindow
{
    private AnimationClip animationClip;
    private GameObject rootObject;
    private Vector2 scrollPosition;

    private List<MissingBinding> missingBindings =
        new List<MissingBinding>();

    private class MissingBinding
    {
        public EditorCurveBinding binding;
        public GameObject replacement;
        public bool expanded;
    }

    [MenuItem("Tools/Animation Reference Fixer")]
    private static void Open()
    {
        GetWindow<AnimationReferenceFixer>(
            "Animation Reference Fixer"
        );
    }

    private void OnGUI()
    {
        EditorGUILayout.Space();

        EditorGUILayout.LabelField(
            "Animation Reference Fixer",
            EditorStyles.boldLabel
        );

        EditorGUILayout.Space();

        animationClip = (AnimationClip)EditorGUILayout.ObjectField(
            "Animation Clip",
            animationClip,
            typeof(AnimationClip),
            false
        );

        rootObject = (GameObject)EditorGUILayout.ObjectField(
            "Animated Root",
            rootObject,
            typeof(GameObject),
            true
        );

        EditorGUILayout.Space();

        GUI.enabled = animationClip != null && rootObject != null;

        if (GUILayout.Button("Find Missing References", GUILayout.Height(30)))
        {
            FindMissingReferences();
        }

        GUI.enabled = true;

        EditorGUILayout.Space();

        if (missingBindings.Count == 0)
        {
            EditorGUILayout.HelpBox(
                "No missing references found.",
                MessageType.Info
            );

            return;
        }

        EditorGUILayout.LabelField(
            "Missing References: " + missingBindings.Count,
            EditorStyles.boldLabel
        );

        EditorGUILayout.Space();

        scrollPosition = EditorGUILayout.BeginScrollView(
            scrollPosition
        );

        for (int i = 0; i < missingBindings.Count; i++)
        {
            DrawMissingBinding(missingBindings[i]);
        }

        EditorGUILayout.EndScrollView();

        EditorGUILayout.Space();

        GUI.enabled = HasAnyReplacement();

        if (GUILayout.Button("Replace All Assigned", GUILayout.Height(35)))
        {
            ReplaceAllAssigned();
        }

        GUI.enabled = true;
    }

    private void DrawMissingBinding(MissingBinding missing)
    {
        EditorGUILayout.BeginVertical("box");

        EditorGUILayout.LabelField(
            "Missing:",
            EditorStyles.boldLabel
        );

        EditorGUILayout.SelectableLabel(
            missing.binding.path,
            EditorStyles.textField,
            GUILayout.Height(18)
        );

        EditorGUILayout.LabelField(
            "Property: " + missing.binding.propertyName
        );

        EditorGUILayout.Space();

        missing.replacement =
            (GameObject)EditorGUILayout.ObjectField(
                "Replace With",
                missing.replacement,
                typeof(GameObject),
                true
            );

        EditorGUILayout.Space();

        GUI.enabled = missing.replacement != null;

        if (GUILayout.Button("Replace"))
        {
            ReplaceBinding(missing);
        }

        GUI.enabled = true;

        EditorGUILayout.EndVertical();

        EditorGUILayout.Space();
    }

    private void FindMissingReferences()
    {
        missingBindings.Clear();

        if (animationClip == null || rootObject == null)
        {
            return;
        }

        EditorCurveBinding[] bindings =
            AnimationUtility.GetCurveBindings(animationClip);

        for (int i = 0; i < bindings.Length; i++)
        {
            EditorCurveBinding binding = bindings[i];

            if (!PathExists(binding.path))
            {
                MissingBinding missing =
                    new MissingBinding();

                missing.binding = binding;
                missing.replacement = null;

                missingBindings.Add(missing);
            }
        }

        UnityEngine.Debug.Log(
            "Animation Reference Fixer found " +
            missingBindings.Count +
            " missing references in " +
            animationClip.name
        );
    }

    private bool PathExists(string path)
    {
        if (string.IsNullOrEmpty(path))
        {
            return true;
        }

        Transform current = rootObject.transform;

        string[] parts = path.Split('/');

        for (int i = 0; i < parts.Length; i++)
        {
            Transform child = current.Find(parts[i]);

            if (child == null)
            {
                return false;
            }

            current = child;
        }

        return true;
    }

    private void ReplaceBinding(MissingBinding missing)
    {
        if (missing.replacement == null)
        {
            return;
        }

        AnimationCurve curve =
            AnimationUtility.GetEditorCurve(
                animationClip,
                missing.binding
            );

        if (curve == null)
        {
            UnityEngine.Debug.LogWarning(
                "Could not read animation curve for " +
                missing.binding.propertyName
            );

            return;
        }

        string newPath =
            AnimationUtility.CalculateTransformPath(
                missing.replacement.transform,
                rootObject.transform
            );

        EditorCurveBinding newBinding =
            missing.binding;

        newBinding.path = newPath;

        Undo.RegisterCompleteObjectUndo(
            animationClip,
            "Fix Animation Reference"
        );

        AnimationUtility.SetEditorCurve(
            animationClip,
            newBinding,
            curve
        );

        AnimationUtility.SetEditorCurve(
            animationClip,
            missing.binding,
            null
        );

        EditorUtility.SetDirty(animationClip);
        AssetDatabase.SaveAssets();

        UnityEngine.Debug.Log(
            "Fixed animation reference:\n" +
            missing.binding.path +
            "\n→\n" +
            newPath
        );

        FindMissingReferences();
    }

    private void ReplaceAllAssigned()
    {
        Undo.RegisterCompleteObjectUndo(
            animationClip,
            "Fix Animation References"
        );

        int count = 0;

        for (int i = missingBindings.Count - 1; i >= 0; i--)
        {
            MissingBinding missing =
                missingBindings[i];

            if (missing.replacement == null)
            {
                continue;
            }

            AnimationCurve curve =
                AnimationUtility.GetEditorCurve(
                    animationClip,
                    missing.binding
                );

            if (curve == null)
            {
                continue;
            }

            string newPath =
                AnimationUtility.CalculateTransformPath(
                    missing.replacement.transform,
                    rootObject.transform
                );

            EditorCurveBinding newBinding =
                missing.binding;

            newBinding.path = newPath;

            AnimationUtility.SetEditorCurve(
                animationClip,
                newBinding,
                curve
            );

            AnimationUtility.SetEditorCurve(
                animationClip,
                missing.binding,
                null
            );

            count++;
        }

        EditorUtility.SetDirty(animationClip);
        AssetDatabase.SaveAssets();

        UnityEngine.Debug.Log(
            "Fixed " +
            count +
            " animation references."
        );

        FindMissingReferences();
    }

    private bool HasAnyReplacement()
    {
        for (int i = 0; i < missingBindings.Count; i++)
        {
            if (missingBindings[i].replacement != null)
            {
                return true;
            }
        }

        return false;
    }
}